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
        guard let ball = ball, gameStatus.state == .onGoing else {
            return
        }

        moveBall(ball: ball)
    }

    func pause() {
        gameStatus.isPaused = true
    }

    func resume() {
        gameStatus.isPaused = false
    }

    override func reset() {
        super.reset()
        self.ball = nil
        resume()
        gameStatus.reset(with: peggleLevel)
        addGamePegs()
    }

    func launchBall(at launchPoint: CGPoint, angle: CGFloat) {
        gameStatus.reduceBallCount()
        self.ball = Ball(center: launchPoint)
        ball?.updateVelocity(speed: Constants.initialBallSpeed, angle: angle)
        ball?.acceleration = Constants.initialAcceleration
    }

    func moveBall(ball: Ball) {
        checkExitFromBottom(ball: ball)
        checkSideCollision(ball: ball)
        checkCollisionWithPeg(ball: ball)

        delegate?.ballDidMove(ball: ball)
        ball.move()
    }

    private func checkExitFromBottom(ball: Ball) {
        guard hasCollidedWithBottom(object: ball) else {
            return
        }
        removePegs(pegsHitByBall)
        self.ball = nil
        delegate?.ballDidExitFromBottom()
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

    private func checkCollisionWithPeg(ball: Ball) {
        for gamePeg in objects where ball.willCollide(with: gamePeg) {
            ball.collide(with: gamePeg)

            gamePeg.increaseHitCount()
            delegate?.didHitPeg(gamePeg: gamePeg)
        }

        if !stuckPegs.isEmpty {
            removePegs(stuckPegs)
        }
    }
}
