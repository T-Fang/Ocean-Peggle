//
//  PeggleLevelTests.swift
//  PeggleTests
//
//  Created by TFang on 30/1/21.
//

import XCTest
@testable import Peggle

class PeggleLevelTests: XCTestCase {

    let bluePeg = Peg(circlePegOfCenter: CGPoint(x: 20, y: 20), color: .blue)
    let bluePegCenter = CGPoint(x: 20, y: 20)
    let invalidCenter = CGPoint(x: 10, y: 10)
    let pointInBluePeg = CGPoint(x: 30, y: 30)
    let centerOfPegBorderingBluePeg = CGPoint(x: 20, y: 60)
    let boundaryPointOfBluePeg = CGPoint(x: 20, y: 0)
    let pointOutsideBluePeg = CGPoint(x: 50, y: 50)
    let pointOutsideBluePeg2 = CGPoint(x: 90, y: 90)

    let orangePeg = Peg(circlePegOfCenter: CGPoint(x: 100, y: 100), color: .orange)
    let orangePegCenter = CGPoint(x: 100, y: 100)

    let boardSize1 = CGSize(width: 200, height: 200)
    let boardSize2 = CGSize(width: 300, height: 400)

    func testConstruct() {
        // Note that level with different `boardSize` will be tested in tests below
        let level1 = PeggleLevel(boardSize: CGSize.zero)
        XCTAssertEqual(level1.boardSize, CGSize.zero)
        XCTAssertEqual(level1.pegs, [])
        XCTAssertNil(level1.levelName)
    }

    func testAddPeg_emptyLevel_success() throws {
        let level = PeggleLevel(boardSize: boardSize1)
        level.addPeg(at: bluePegCenter, shape: .circle, color: .blue)
        let peg = try XCTUnwrap(level.pegs.first)
        XCTAssertEqual(peg.center, bluePegCenter)
        XCTAssertEqual(peg.color, .blue)
    }

    func testAddPeg_outOfBoundary_failure() {
        let level = PeggleLevel(boardSize: boardSize2)
        level.addPeg(at: invalidCenter, shape: .circle, color: .orange)
        XCTAssertTrue(level.pegs.isEmpty)
    }

    func testAddPeg_overlapsWithExistingPegs_failure() {
        let level = PeggleLevel()
        level.addPeg(at: bluePegCenter, shape: .circle, color: .orange)
        level.addPeg(at: pointInBluePeg, shape: .circle, color: .blue)
        XCTAssertEqual(level.pegs.count, 1)
    }

    func testAddPeg_bordersExistingPegs_failure() {
        let level = PeggleLevel(boardSize: boardSize1)
        level.addPeg(at: bluePegCenter, shape: .circle, color: .blue)
        level.addPeg(at: centerOfPegBorderingBluePeg, shape: .circle, color: .orange)
        XCTAssertEqual(level.pegs.count, 1)
    }

    func testGetPegThatContains_noPegContainsThePoint_nil() {
        let level = PeggleLevel(boardSize: boardSize2)
        level.addPeg(at: bluePegCenter, shape: .circle, color: .blue)
        XCTAssertNil(level.getObject(CGPoint.zero))
        XCTAssertNil(level.getObject(pointOutsideBluePeg))
    }

    func testGetPegThatContains_pointOnPegBoundary_success() throws {
        let level = PeggleLevel()
        level.addPeg(at: bluePegCenter, shape: .circle, color: .blue)
        let peg = try XCTUnwrap(level.getObject(boundaryPointOfBluePeg))
        XCTAssertEqual(peg, bluePeg)
    }

    func testGetPegThatContains_pointInsidePeg_success() throws {
        let level = PeggleLevel(boardSize: boardSize1)
        level.addPeg(at: bluePegCenter, shape: .circle, color: .blue)
        let peg = try XCTUnwrap(level.getObject(bluePegCenter))
        XCTAssertEqual(peg, bluePeg)
    }

    func testRemovePeg_noPegContainsThePoint_nil() {
        let level = PeggleLevel(boardSize: boardSize2)
        level.addPeg(at: bluePegCenter, shape: .circle, color: .blue)
        level.removePeg(at: CGPoint.zero)
        level.removePeg(at: pointOutsideBluePeg)
        XCTAssertEqual(level.pegs.count, 1)
    }

    func testRemovePeg_pointOnPegBoundary_success() {
        let level = PeggleLevel()
        level.addPeg(at: bluePegCenter, shape: .circle, color: .blue)
        level.removePeg(at: boundaryPointOfBluePeg)
        XCTAssertTrue(level.pegs.isEmpty)
    }

    func testRemovePeg_pointInsidePeg_success() {
        let level = PeggleLevel(boardSize: boardSize1)
        level.addPeg(at: bluePegCenter, shape: .circle, color: .blue)
        level.removePeg(at: bluePegCenter)
        XCTAssertTrue(level.pegs.isEmpty)
    }

    func testMovePeg_validNewPositionNoOverlappingWithOriginalPeg_success() throws {
        let level = PeggleLevel(boardSize: boardSize2)
        level.addPeg(at: bluePegCenter, shape: .circle, color: .blue)
        let peg = try XCTUnwrap(level.moveObject(from: bluePegCenter, to: pointOutsideBluePeg))
        XCTAssertEqual(peg.center, pointOutsideBluePeg)
    }
    func testMovePeg_validNewPositionButOverlapsWithOriginalPeg_success() throws {
        let level = PeggleLevel()
        level.addPeg(at: bluePegCenter, shape: .circle, color: .blue)
        let peg = try XCTUnwrap((level.moveObject(from: bluePegCenter, to: pointInBluePeg)))
        XCTAssertEqual(peg.center, pointInBluePeg)
    }
    func testMovePeg_newPegOutOfBoardBoundary_returnNil() {
        let level = PeggleLevel(boardSize: boardSize1)
        level.addPeg(at: bluePegCenter, shape: .circle, color: .blue)
        XCTAssertNil(level.moveObject(from: bluePegCenter, to: invalidCenter))
        let peg = level.pegs.first
        XCTAssertEqual(peg?.center, bluePegCenter)
    }
    func testMovePeg_newPegOverlapsWithExistingPegs_returnNil() {
        let level = PeggleLevel(boardSize: boardSize2)
        level.addPeg(at: bluePegCenter, shape: .circle, color: .blue)
        level.addPeg(at: pointOutsideBluePeg, shape: .circle, color: .orange)
        XCTAssertNil(level.moveObject(from: pointOutsideBluePeg, to: pointInBluePeg))
    }

    func testResizePeg_negativeScale_pegRemainUnchanged() throws {
        let level = PeggleLevel(boardSize: boardSize2)
        level.addPeg(at: bluePegCenter, shape: .circle, color: .blue)
        let peg = try XCTUnwrap(level.resizeObject(peg: bluePeg, by: -1))
        XCTAssertEqual(peg, bluePeg)
    }
    func testResizePeg_invalidSize_returnNil() {
        let level = PeggleLevel()
        level.addPeg(at: orangePegCenter, shape: .circle, color: .orange)
        XCTAssertNil(level.resizeObject(peg: orangePeg, by: 4))
        XCTAssertNil(level.resizeObject(peg: orangePeg, by: 0.01))
    }
    func testResizePeg_outOfGameBoard_returnNil() {
        let level = PeggleLevel(boardSize: boardSize1)
        level.addPeg(at: bluePegCenter, shape: .circle, color: .blue)
        XCTAssertNil(level.resizeObject(peg: bluePeg, by: 1.2))
    }
    func testResizePeg_newPegOverlapsWithExistingPegs_returnNil() {
        let level = PeggleLevel(boardSize: boardSize2)
        let peg = Peg(circlePegOfCenter: pointOutsideBluePeg, color: .blue)
        level.addPeg(at: pointOutsideBluePeg, shape: .circle, color: .blue)
        level.addPeg(at: pointOutsideBluePeg2, shape: .circle, color: .orange)
        XCTAssertNil(level.resizeObject(peg: peg, by: 2))
    }
    func testResizePeg_validSize_success() throws {
        let level = PeggleLevel()
        level.addPeg(at: orangePegCenter, shape: .circle, color: .orange)
        let peg = try XCTUnwrap(level.resizeObject(peg: orangePeg, by: 0.8))
        XCTAssertEqual(peg.physicsShape.radius, 16)
    }

    func testResetPegBoard() {
        let level = PeggleLevel()

        level.addPeg(at: bluePegCenter, shape: .circle, color: .blue)
        level.addPeg(at: pointOutsideBluePeg, shape: .circle, color: .blue)
        level.resetPegBoard()
        XCTAssertTrue(level.pegs.isEmpty)
    }

    func testGetPegCounts_emptyLevel_allZero() {
        let level = PeggleLevel(boardSize: boardSize1)
        let counts = level.getPegCounts()
        XCTAssertEqual(counts[.circle]?[.blue], 0)
        XCTAssertEqual(counts[.circle]?[.orange], 0)
    }

    func testGetPegCounts_onePeg() {
        let level = PeggleLevel(boardSize: boardSize2)
        level.addPeg(at: bluePegCenter, shape: .circle, color: .blue)
        let counts = level.getPegCounts()
        XCTAssertEqual(counts[.circle]?[.blue], 1)
        XCTAssertEqual(counts[.circle]?[.orange], 0)
    }

    func testGetPegCounts_multiplePegs() {
        let level = PeggleLevel()
        level.addPeg(at: bluePegCenter, shape: .circle, color: .blue)
        level.addPeg(at: pointOutsideBluePeg, shape: .circle, color: .orange)
        level.addPeg(at: pointOutsideBluePeg2, shape: .circle, color: .orange)
        let counts = level.getPegCounts()
        XCTAssertEqual(counts[.circle]?[.blue], 1)
        XCTAssertEqual(counts[.circle]?[.orange], 2)
    }

    func testGetOragnePegCount_emptyLevel_zero() {
        let level = PeggleLevel()
        XCTAssertEqual(level.oragnePegCount(), 0)
    }

    func testGetOragnePegCount_containsOrangePeg_success() {
        let level = PeggleLevel(boardSize: boardSize2)
        level.addPeg(at: bluePegCenter, shape: .circle, color: .blue)
        level.addPeg(at: pointOutsideBluePeg, shape: .circle, color: .blue)
        level.addPeg(at: pointOutsideBluePeg2, shape: .circle, color: .orange)
        XCTAssertEqual(level.oragnePegCount(), 1)
    }

    func testHasOrangePeg_emptyLevel_false() {
        let level = PeggleLevel(boardSize: boardSize1)
        XCTAssertFalse(level.hasOrangePeg())
    }
    func testHasOrangePeg_containsOrangePeg_true() {
        let level = PeggleLevel(boardSize: boardSize2)
        level.addPeg(at: bluePegCenter, shape: .circle, color: .blue)
        level.addPeg(at: pointOutsideBluePeg, shape: .circle, color: .blue)
        level.addPeg(at: pointOutsideBluePeg2, shape: .circle, color: .orange)
        XCTAssertTrue(level.hasOrangePeg())
    }
}
