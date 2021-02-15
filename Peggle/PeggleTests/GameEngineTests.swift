//
//  GameEngineTests.swift
//  PeggleTests
//
//  Created by TFang on 13/2/21.
//

import XCTest
@testable import Peggle

class GameEngineTests: XCTestCase {
    // Note that only some basic methods are tested in unit test,
    // Other methods and attributes are tested in integration test

    let pi = CGFloat(Double.pi)

    let level1 = PeggleLevel()
    let level2 = PeggleLevel(boardSize: CGSize(width: 300, height: 400))
    let level1Name = "level1"
    let level2Name = "level2"
    let pegCenter1 = CGPoint(x: 20, y: 20)
    let pegCenter2 = CGPoint(x: 100, y: 100)

    var engine1 = GameEngine(frame: .zero, peggleLevel: PeggleLevel())
    var engine2 = GameEngine(frame: CGRect(x: 0, y: 0, width: 300, height: 450), peggleLevel: PeggleLevel())

    override func setUp() {
        super.setUp()
        level1.levelName = level1Name
        level2.levelName = level2Name

        level2.addPeg(at: pegCenter1, shape: .circle, color: .blue)
        level2.addPeg(at: pegCenter2, shape: .circle, color: .orange)

        engine1 = GameEngine(frame: .zero, peggleLevel: level1)
        engine2 = GameEngine(frame: CGRect(x: 0, y: 0, width: 300, height: 450), peggleLevel: level2)
    }

    func testLaunchBall() {
        engine1.launchBall(at: .zero, angle: .zero)
        XCTAssertEqual(engine1.gameStatus.ballCount, Constants.defaultBallCount - 1)
        XCTAssertFalse(engine1.canFire)
        // Note that launch ball from negative point and angle is allowed,
        // so that more features can be added in the future
        // (e.g. let spooky ball come from outside of the screen)
        engine2.launchBall(at: CGPoint(x: -10, y: -10), angle: CGFloat(-pi))
        XCTAssertEqual(engine2.gameStatus.ballCount, Constants.defaultBallCount - 1)
        XCTAssertFalse(engine2.canFire)
    }

    func testReset() {
        engine1.launchBall(at: CGPoint(x: -10, y: -10), angle: CGFloat(-pi))
        engine2.launchBall(at: .zero, angle: .zero)
        engine1.reset()
        engine2.reset()
        XCTAssertEqual(engine1.gameStatus.ballCount, Constants.defaultBallCount)
        XCTAssertEqual(engine2.gameStatus.ballCount, Constants.defaultBallCount)
        XCTAssertEqual(engine2.gameStatus.orangePegCount, 1)
    }

}
