//
//  GameEngine.swift
//  Peggle
//
//  Created by TFang on 10/2/21.
//

import UIKit

class GameEngine: PhysicsWorld<GamePeg> {

    weak var delegate: GameEventHandlerDelegate? {
        didSet {
            gameStatus.delegate = delegate
        }
    }

    private var ball: Ball?
    private var bucket: Bucket
    private(set) var gameStatus: GameStatus
    private let peggleLevel: PeggleLevel

    // pegs that got hit by the current ball
    var pegsHitByBall: [GamePeg] {
        objects.filter({ $0.hitCount > 0 })
    }
    var stuckPegs: [GamePeg] {
        objects.filter({ $0.hitCount >= Constants.hitCountForStuckPeg })
    }

    var canFire: Bool {
        ball == nil && gameStatus.state == .onGoing
    }

    init(frame: CGRect, peggleLevel: PeggleLevel) {
        self.peggleLevel = peggleLevel
        gameStatus = GameStatus(peggleLevel: peggleLevel)
        bucket = Bucket(gameFrame: frame)
        super.init(frame: frame)

        addGamePegs()

        let displayLink = CADisplayLink(target: self, selector: #selector(update))
        displayLink.add(to: .current, forMode: .common)

    }
    private func addGamePegs() {
        peggleLevel.pegs
            .forEach({ add(GamePeg(peg: $0.offsetBy(x: 0, y: Constants.defaultCannonHeight))) })
    }

    @objc private func update(displayLink: CADisplayLink) {
        guard gameStatus.state == .onGoing else {
            return
        }

        moveBucket()
        delegate?.bucketDidMove(bucket: bucket)

        guard let ball = ball else {
            return
        }
        moveBall(ball: ball)
        delegate?.ballDidMove(ball: ball)
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
        
        addGamePegs()
    }

    func launchBall(at launchPoint: CGPoint, angle: CGFloat) {
        gameStatus.reduceBallCount()
        self.ball = Ball(center: launchPoint)
        ball?.updateVelocity(speed: Constants.initialBallSpeed, angle: angle)
        ball?.acceleration = Constants.initialAcceleration
    }
    func moveBucket() {
        bucket.move()
        if hasCollidedWithSide(object: bucket) {
            bucket.reflectVelocityAlongXAxis()
        }
    }
    func moveBall(ball: Ball) {
        checkCollisionWithObjectAndMove(ball: ball)

        checkExitFromBottom(ball: ball)
        checkSideCollision(ball: ball)
    }

    private func checkExitFromBottom(ball: Ball) {
        guard hasCollidedWithBottom(object: ball) else {
            return
        }
        removeBallAndHitPegs()
    }
    private func removeBallAndHitPegs() {
        removePegs(pegsHitByBall)
        self.ball = nil
        delegate?.didRemoveBall()
    }
    private func removePegs(_ pegsToBeRemoved: [GamePeg]) {
        delegate?.willRemovePegs(gamePegs: pegsToBeRemoved)
        gameStatus.updateStatusAfterRemoval(of: pegsToBeRemoved)
        remove(pegsToBeRemoved)
    }

    private func checkSideCollision(ball: Ball) {
        if hasCollidedWithSide(object: ball) {
            ball.reflectVelocityAlongXAxis()
        }
    }

    private func checkCollisionWithObjectAndMove(ball: Ball) {
        guard objects.allSatisfy({ !ball.willCollide(with: $0) }) else {
            checkCollisionWithPeg(ball: ball)
            return
        }

        guard !ball.willCollide(with: bucket) else {
            checkCollisionWithBucket(ball: ball)
            return
        }

        ball.move()
    }
    private func checkCollisionWithPeg(ball: Ball) {
        let pegsWillBeHit = objects.filter({ ball.willCollide(with: $0) })
        for gamePeg in pegsWillBeHit {
            ball.collide(with: gamePeg)

            gamePeg.increaseHitCount()
            delegate?.didHitPeg(gamePeg: gamePeg)
        }

        if !stuckPegs.isEmpty {
            removePegs(stuckPegs)
        }
    }
    private func checkCollisionWithBucket(ball: Ball) {
        if bucket.isEnteringBucket(ball: ball) {
            gameStatus.increaseBallCount()
            delegate?.showMessage(Constants.extraBallMessage)
            removeBallAndHitPegs()
        } else {
            ball.collide(with: bucket)
            delegate?.didHitBucket()
        }
    }
}
