//
//  GameStatusTests.swift
//  PeggleTests
//
//  Created by TFang on 13/2/21.
//

import XCTest
@testable import Peggle

class GameStatusTests: XCTestCase {

    let level1 = PeggleLevel()
    let level2 = PeggleLevel(boardSize: CGSize(width: 200, height: 200))
    let level3 = PeggleLevel(boardSize: CGSize(width: 300, height: 400))
    let level1Name = "level1"
    let level2Name = "level2"
    let level3Name = "level3"
    let pegCenter1 = CGPoint(x: 20, y: 20)
    let pegCenter2 = CGPoint(x: 100, y: 100)

    let blueGamePeg = GamePeg(peg: Peg(circlePegOfCenter: CGPoint(x: 50, y: 50), color: .blue))
    let orangeGamePeg = GamePeg(peg: Peg(circlePegOfCenter: CGPoint(x: 100, y: 100), color: .orange))

    override func setUp() {
        super.setUp()
        level1.levelName = level1Name
        level2.levelName = level2Name
        level3.levelName = level3Name

        level2.addPeg(at: pegCenter2, shape: .circle, color: .blue)

        level3.addPeg(at: pegCenter1, shape: .circle, color: .blue)
        level3.addPeg(at: pegCenter2, shape: .circle, color: .orange)
    }

    func testConstruct() {
        let status1 = GameStatus(peggleLevel: level1)
        let status2 = GameStatus(peggleLevel: level2)
        let status3 = GameStatus(peggleLevel: level3)
        XCTAssertEqual(status1.ballCount, Constants.defaultBallCount)
        XCTAssertEqual(status2.ballCount, Constants.defaultBallCount)
        XCTAssertEqual(status3.ballCount, Constants.defaultBallCount)
        XCTAssertEqual(status1.orangePegCount, 0)
        XCTAssertEqual(status2.orangePegCount, 0)
        XCTAssertEqual(status3.orangePegCount, 1)
    }

    func testState() {
        let status1 = GameStatus(peggleLevel: level1)
        let status2 = GameStatus(peggleLevel: level2)
        let status3 = GameStatus(peggleLevel: level3)
        XCTAssertEqual(status1.state, .win)
        XCTAssertEqual(status2.state, .win)
        XCTAssertEqual(status3.state, .onGoing)
        status3.isPaused = true
        XCTAssertEqual(status3.state, .paused)
    }

    func testUpdateStatusAfterRemoval() {
        let status3 = GameStatus(peggleLevel: level3)
        status3.updateStatusAfterRemoval(of: [])
        XCTAssertEqual(status3.orangePegCount, 1)

        status3.updateStatusAfterRemoval(of: [blueGamePeg, orangeGamePeg])
        XCTAssertEqual(status3.orangePegCount, 0)
    }

    func testReset() {
        let status1 = GameStatus(peggleLevel: level1)
        let status3 = GameStatus(peggleLevel: level3)

        status3.updateStatusAfterRemoval(of: [orangeGamePeg])
        status3.reduceBallCount()
        status1.updateStatusAfterRemoval(of: [blueGamePeg])
        status1.increaseBallCount()
        XCTAssertEqual(status3.orangePegCount, 0)
        XCTAssertEqual(status3.ballCount, Constants.defaultBallCount - 1)
        XCTAssertEqual(status1.orangePegCount, 0)
        XCTAssertEqual(status1.ballCount, Constants.defaultBallCount + 1)

        status3.reset(with: level3)
        status1.reset(with: level1)
        XCTAssertEqual(status3.orangePegCount, 1)
        XCTAssertEqual(status3.ballCount, Constants.defaultBallCount)
        XCTAssertEqual(status1.orangePegCount, 0)
        XCTAssertEqual(status1.ballCount, Constants.defaultBallCount)
    }

}
