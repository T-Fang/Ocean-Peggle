//
//  GameStatus.swift
//  Peggle
//
//  Created by TFang on 10/2/21.
//

class GameStatus {
    weak var delegate: GameEventHandlerDelegate?
    var isPaused = false
    var timeLeft = 3_600 {
        didSet {
            // based on 60Hz refresh rate
            delegate?.timeDidChange(time: Float(timeLeft) / 60)
        }
    }
    var hasBallOnScreen = false
    private(set) var score = 0 {
        didSet {
            delegate?.scoreDidChange(score: score)
        }
    }
    var spookyCount = 0
    private(set) var ballCount: Int {
        didSet {
            delegate?.ballCountDidChange(ballCount: ballCount)
        }
    }
    private(set) var orangePegCount: Int {
        didSet {
            delegate?.orangePegCountDidChange(orangePegCount: orangePegCount)
        }
    }

    private(set) var floatBubblePercentage: Double = 0 {
        didSet {
            if floatBubblePercentage < 0 {
                floatBubblePercentage = 0
                delegate?.floatBubbleDidRunOut()
            }
            delegate?.floatBubbleDidChange(percentage: floatBubblePercentage)
        }
    }

    var isBallFloating = false

    var state: State {

        guard timeLeft > 0 else {
            return .lose
        }

        if !hasBallOnScreen {
            guard orangePegCount > 0 else {
                return .win
            }

            guard ballCount > 0 else {
                return .lose
            }
        }

        return isPaused ? .paused : .onGoing
    }

    init(peggleLevel: PeggleLevel) {
        ballCount = Constants.defaultBallCount
        orangePegCount = peggleLevel.oragnePegCount
    }

    func reset(with peggleLevel: PeggleLevel) {
        isPaused = false
        ballCount = Constants.defaultBallCount
        orangePegCount = peggleLevel.oragnePegCount
        timeLeft = 3_600
        score = 0
        spookyCount = 0
        floatBubblePercentage = 0
        isBallFloating = false
    }

    func updateStatusAfterRemoval(of pegsToBeRemoved: [GamePeg]) {
        let orangePegCount = pegsToBeRemoved.filter({ $0.color == .orange }).count
        let otherPegCount = pegsToBeRemoved.filter({ $0.color != .orange }).count

        self.orangePegCount -= orangePegCount

        score += pegsToBeRemoved.count * (otherPegCount * Constants.otherPegsScore
                                            + orangePegCount * Constants.orangePegScore)
    }

    func increaseBallCount() {
        ballCount += 1
    }

    func launchBall() {
        ballCount -= 1
        hasBallOnScreen = true
    }
    func removeBall() {
        hasBallOnScreen = false
    }

    func reduceTime() {
        timeLeft -= 1
        if isBallFloating, floatBubblePercentage > 0, hasBallOnScreen {
            floatBubblePercentage -= Constants.floatingBubbleReduceRate
        }
    }

    func refillFloatBubble() {
        floatBubblePercentage = 100
    }
}
