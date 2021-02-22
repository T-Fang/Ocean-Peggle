//
//  GameStatus.swift
//  Peggle
//
//  Created by TFang on 10/2/21.
//

class GameStatus {
    weak var delegate: GameEventHandlerDelegate?
    var isPaused = false

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

    var state: State {
        guard orangePegCount > 0 else {
            return .win
        }
        guard ballCount > 0 else {
            return .lose
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
    }

    func updateStatusAfterRemoval(of pegsToBeRemoved: [GamePeg]) {
        for peg in pegsToBeRemoved where peg.color == .orange {
            orangePegCount -= 1
        }
    }

    func increaseBallCount() {
        ballCount += 1
    }

    func reduceBallCount() {
        ballCount -= 1
    }
}
