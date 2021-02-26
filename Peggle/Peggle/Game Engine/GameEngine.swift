//
//  GameEngine.swift
//  Peggle
//
//  Created by TFang on 10/2/21.
//

import UIKit

class GameEngine: PhysicsWorld {
    private weak var displayLink: CADisplayLink?

    weak var delegate: GameEventHandlerDelegate? {
        didSet {
            gameStatus.delegate = delegate
        }
    }

    private(set) var ball: Ball?
    private(set) var bucket: Bucket
    private(set) var gameStatus: GameStatus
    private let peggleLevel: PeggleLevel
    private var master: Master
    var pegs: [GamePeg] {
        objects.compactMap({ $0 as? GamePeg })
    }
    var blocks: [GameBlock] {
        objects.compactMap({ $0 as? GameBlock })
    }

    private(set) var spookyCount: Int {
        get {
            gameStatus.spookyCount
        }
        set {
            newValue > 0 ? bucket.close() : bucket.open()
            gameStatus.spookyCount = newValue
        }
    }

    // pegs that got hit by the current ball
    var pegsHitByBall: [GamePeg] {
        pegs.filter({ $0.hitCount > 0 })
    }
    var stuckObjects: [PhysicsObject] {
        objects.filter({ $0.isStuck })
    }
    var overlappingObjects: [PhysicsObject] {
        guard let ball = ball else {
            return []
        }
        return objects.filter({ ball.overlaps(with: $0) })
    }
    var objectsWillBeHit: [PhysicsObject] {
        guard let ball = ball else {
            return []
        }
        return objects.filter({ ball.willCollide(with: $0) })
    }
    var canMoveFreely: Bool {
        overlappingObjects.isEmpty && objectsWillBeHit.isEmpty
    }
    var canFire: Bool {
        ball == nil && gameStatus.state == .onGoing
    }

    init(frame: CGRect, peggleLevel: PeggleLevel, master: Master) {
        self.peggleLevel = peggleLevel
        self.gameStatus = GameStatus(peggleLevel: peggleLevel)
        self.bucket = Bucket(gameFrame: frame)
        self.master = master
        super.init(frame: frame)

        setUpGame()

        let displayLink = CADisplayLink(target: self, selector: #selector(update))
        displayLink.add(to: .current, forMode: .common)

        self.displayLink = displayLink
    }

    @objc private func update(displayLink: CADisplayLink) {
        guard gameStatus.state == .onGoing else {
            return
        }
        gameStatus.reduceTime()

        moveObjects()
        moveBall()

        checkCollisionWithWalls()
        checkExitFromBottom()

        delegate?.objectsDidMove()
    }

    /// After all attributes are initialized, set up the game
    private func setUpGame() {
        add(bucket)
        addGamePegs()
        addGameBlocks()
        addWalls()
    }
    private func addWalls() {
        add(leftWall)
        add(rightWall)
        add(topWall)
    }
    private func addGamePegs() {
        peggleLevel.pegs.forEach({ add(GamePeg(peg: $0.offsetBy(x: 0, y: Constants.cannonHeight))) })
    }
    private func addGameBlocks() {
        peggleLevel.blocks.forEach({ add(GameBlock(block: $0.offsetBy(x: 0, y: Constants.cannonHeight))) })
    }

    private func checkCollisionWithWalls() {
        guard let ball = self.ball else {
            return
        }
        if hasCollidedWithTop(object: ball) {
            ball.center.y = frame.minY + Constants.ballRadius
            if ball.velocity.dy < 0 {
                ball.reflectVelocityAlongYAxis()
            }
        }
        if hasCollidedWithLeftSide(object: ball) {
            ball.center.x = frame.minX + Constants.ballRadius
            if ball.velocity.dx < 0 {
                ball.reflectVelocityAlongXAxis()
            }
        }
        if hasCollidedWithRightSide(object: ball) {
            ball.center.x = frame.maxX - Constants.ballRadius
            if ball.velocity.dx > 0 {
                ball.reflectVelocityAlongXAxis()
            }
        }
    }
    private func checkExitFromBottom() {
        guard let ball = self.ball else {
            return
        }
        if hasCollidedWithBottom(object: ball) {
            checkEndTurn()
        }
    }
    private func checkEndTurn() {
        remove(pegsHitByBall)

        guard spookyCount == 0 else {
            ball?.center.y = frame.minY + Constants.ballRadius
            spookyCount -= 1
            return
        }
        removeBallAndHitPegs()
    }
    private func moveObjects() {
        objects.compactMap({ $0 as? MovablePhysicsObject }).forEach({ $0.move() })
    }

    override func reset() {
        super.reset()
        ball = nil
        bucket.reset()
        gameStatus.reset(with: peggleLevel)

        setUpGame()
    }

    private func removeBallAndHitPegs() {
        remove(pegsHitByBall)
        self.ball = nil
        gameStatus.removeBall()

        delegate?.didRemoveBall()
    }

    override func remove(_ objectsToBeRemoved: [PhysicsObject]) {
        let pegs = objectsToBeRemoved.compactMap({ $0 as? GamePeg })
        let blocks = objectsToBeRemoved.compactMap({ $0 as? GameBlock })

        pegs.forEach({ remove(peg: $0) })
        blocks.forEach({ remove(block: $0) })
        gameStatus.updateStatusAfterRemoval(of: pegs)
    }
    private func remove(block: GameBlock) {
        delegate?.willRemoveBlock(gameBlock: block)
        super.remove(block)
    }
    private func remove(peg: GamePeg) {
        delegate?.willRemovePeg(gamePeg: peg)
        super.remove(peg)

    }

    private func resolveOverlaps() {
        var count = 0
        while let ball = self.ball,
              let overlappingObject = overlappingObjects.first,
              count <= Constants.maxNumberOfMovementAdjustment {
            count += 1

            ball.move()
            hit(overlappingObject)
        }
    }
    private func resolveCollision() {
        var count = 0
        while let ball = self.ball,
              let nearest = ball.nearestCollidingObject(among: objects),
              count <= Constants.maxNumberOfMovementAdjustment {
            count += 1

            if let pegToBeHit = nearest as? GamePeg {
                ball.collide(with: pegToBeHit)
                hitPeg(pegToBeHit)
                continue
            }
            if nearest is Bucket {
                checkCollisionWithBucket(ball: ball)
                continue
            }

            ball.collide(with: nearest)
            hit(nearest)

        }
    }
    private func hit(_ object: PhysicsObject) {
        if let block = object as? GameBlock {
            hitBlock(block)
        }
        if let peg = object as? GamePeg {
            hitPeg(peg)
        }
    }
    private func hitBlock(_ gameBlock: GameBlock) {
        gameBlock.increaseHitCount()
        delegate?.didHitBlock()
    }
    private func hitPeg(_ gamePeg: GamePeg) {
        gamePeg.increaseHitCount()
        delegate?.didHitPeg()

        if gamePeg.color == .green && gamePeg.hitCount == 1 {
            activatePowerUp(greenPeg: gamePeg)
        }
    }
    private func activatePowerUp(greenPeg: GamePeg) {
        switch master {
        case .Splork:
            pegs
                .filter({ $0.hitCount == 0 })
                .filter({ greenPeg.center.distanceTo($0.center) <= Constants.spaceBlastRadius })
                .forEach({ hitPeg($0) })

            delegate?.didActivateSpaceBlast(at: greenPeg.center)
            delegate?.showMessage(Constants.spaceBlastActivatedMessage)
        case .Renfield:
            spookyCount += 1
            delegate?.didActivateSpookyBall()
            delegate?.showMessage(Constants.spookyBallActivatedMessage)
        case .Mike:
            gameStatus.refillFloatBubble()
            delegate?.showMessage(Constants.blowBubbleActivatedMessage)
        }
    }
    private func checkCollisionWithBucket(ball: Ball) {
        guard !ball.overlaps(with: bucket) else {
            ball.move()
            return
        }
        if bucket.willEnterBucket(ball: ball) {
            gameStatus.increaseBallCount()
            delegate?.showMessage(Constants.extraBallMessage)
            removeBallAndHitPegs()
        } else {
            ball.collide(with: bucket)
            delegate?.didHitBucket()
        }
    }

}

extension GameEngine {
    func launchBall(at launchPoint: CGPoint, angle: CGFloat) {
        gameStatus.launchBall()
        self.ball = Ball(center: launchPoint, angle: angle)

        delegate?.objectsDidMove()
    }

    func moveBall() {
        guard canMoveFreely else {
            var count = 0
            while !canMoveFreely, count <= Constants.maxNumberOfMovementAdjustment {
                count += 1

                if !stuckObjects.isEmpty {
                    remove(stuckObjects)
                }
                resolveOverlaps()
                resolveCollision()
            }
            return
        }
        ball?.move()
    }

    func playPause() {
        gameStatus.isPaused.toggle()
    }

    func floatBall() {
        guard gameStatus.floatBubblePercentage > 0 else {
            unfloatBall()
            return
        }
        guard let ball = self.ball else {
            return
        }
        ball.float()
        gameStatus.isBallFloating = true
    }

    func unfloatBall() {
        ball?.unfloat()
        gameStatus.isBallFloating = false
    }
}

extension GameEngine {
    func stopDisplayLink() {
        displayLink?.invalidate()
    }
}
