//
//  GameEngine.swift
//  Peggle
//
//  Created by TFang on 10/2/21.
//

import UIKit

class GameEngine: PhysicsWorld {

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

    private(set) var spookyCount = 0 {
        didSet {
            spookyCount > 0 ? bucket.close() : bucket.open()
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

    }

    /// After all attributes are initialized, set up the game
    private func setUpGame() {
        add(bucket)
        addGamePegs()
        addGameBlocks()
        addWalls()
    }
    private func addGamePegs() {
        peggleLevel.pegs.forEach({ add(GamePeg(peg: $0.offsetBy(x: 0, y: Constants.cannonHeight))) })
    }
    private func addGameBlocks() {
        peggleLevel.blocks.forEach({ add(GameBlock(block: $0.offsetBy(x: 0, y: Constants.cannonHeight))) })
    }
    @objc private func update(displayLink: CADisplayLink) {
        guard gameStatus.state != .paused else {
            return
        }

        moveObjects()
        moveBall()

        delegate?.objectsDidMove()
    }

    private func moveObjects() {
        objects.compactMap({ $0 as? MovablePhysicsObject }).forEach({ $0.move() })
    }
    func pause() {
        gameStatus.isPaused = true
    }

    func resume() {
        gameStatus.isPaused = false
    }
    override func reset() {
        super.reset()
        ball = nil
        bucket.reset()
        gameStatus.reset(with: peggleLevel)

        setUpGame()
    }

    func launchBall(at launchPoint: CGPoint, angle: CGFloat) {
        gameStatus.reduceBallCount()
        self.ball = Ball(center: launchPoint)
        ball?.updateVelocity(speed: Constants.initialBallSpeed, angle: angle)
        ball?.acceleration = Constants.initialAcceleration
        delegate?.objectsDidMove()
    }

    func moveBall() {
        guard canMoveFreely else {
            while !canMoveFreely {
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

    private func removeBallAndHitPegs() {
        remove(pegsHitByBall)
        self.ball = nil
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
        while let ball = self.ball,
              let overlappingObject = overlappingObjects.first {
            if overlappingObject is Bucket {
                checkCollisionWithBucket(ball: ball)
            } else {
                ball.move()
                hit(overlappingObject)
            }
        }
    }
    private func resolveCollision() {

        while let ball = self.ball,
              let nearest = ball.nearestCollidingObject(among: objects) {
            if let pegToBeHit = nearest as? GamePeg {
                ball.collide(with: pegToBeHit)
                hitPeg(pegToBeHit)
                continue
            }
            if nearest is Bucket {
                checkCollisionWithBucket(ball: ball)
                continue
            }
            if let wall = nearest as? Wall, wall.type == .bottomWall {
                checkEndTurn()
                continue
            }

            ball.collide(with: nearest)
            hit(nearest)
        }
    }
    private func checkEndTurn() {
        remove(pegsHitByBall)

        guard spookyCount == 0 else {
            ball?.moveToSpookyBallPosition()
            spookyCount -= 1
            return
        }
        removeBallAndHitPegs()
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
    }
    private func hitPeg(_ gamePeg: GamePeg) {
        gamePeg.increaseHitCount()

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
            delegate?.showMessage(Constants.spookyBallActivatedMessage)
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
