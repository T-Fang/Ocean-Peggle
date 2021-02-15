//
//  PegTests.swift
//  PeggleTests
//
//  Created by TFang on 30/1/21.
//

import XCTest
@testable import Peggle

class PegTests: XCTestCase {
    let origin = CGPoint(x: 0, y: 0)

    let blueCirclePeg1 = Peg(circlePegOfCenter: CGPoint(x: 500, y: 500), color: .blue)
    let pointInsideBlueCirclePeg1 = CGPoint(x: 499, y: 499)
    let boundaryPointOfBlueCirclePeg1 = CGPoint(x: 520, y: 500)
    let sameBlueCirclePeg1 = Peg(circlePegOfRadius: 20, center: CGPoint(x: 500, y: 500), color: .blue)
    let blueCirclePeg2 = Peg(circlePegOfCenter: CGPoint(x: 540, y: 500), color: .blue)
    let orangeCirclePeg1 = Peg(circlePegOfRadius: 30, center: CGPoint(x: 100, y: 100), color: .orange)
    let orangeCirclePeg2 = Peg(circlePegOfRadius: 40, center: CGPoint(x: 100, y: 100), color: .orange)

    func testConstruct_negativeRadius_returnCirclePegWithZeroRadius() {
        let center = CGPoint(x: 0, y: 0)
        let peg = Peg(circlePegOfRadius: -10, center: center, color: .blue)
        XCTAssertEqual(peg.center, center)
        XCTAssertEqual(peg.color, .blue)
        XCTAssertEqual(peg.shape, .circle)
        XCTAssertEqual(peg.physicsShape.radius, 0)
    }

    func testConstruct_negativeCenter_success() {
        // Note that peg with negative center is allowed.
        // However, what is not allowed is that peg appearing on the game board.
        let negativePoint = CGPoint(x: -1, y: -1)
        let peg = Peg(circlePegOfRadius: 1, center: negativePoint, color: .blue)
        XCTAssertEqual(peg.center, negativePoint)
        XCTAssertEqual(peg.color, .blue)
        XCTAssertEqual(peg.shape, .circle)
    }

    func testConstruct() {
        let center = CGPoint(x: 5, y: 5)
        let peg = Peg(circlePegOfRadius: 3, center: center, color: .blue)
        XCTAssertEqual(peg.center, center)
        XCTAssertEqual(peg.color, .blue)
        XCTAssertEqual(peg.shape, .circle)
    }

    func testContains_pointInsidePeg_true() {
        XCTAssertTrue(blueCirclePeg1.contains(pointInsideBlueCirclePeg1))
    }
    func testContains_boundaryPoint_true() {
        XCTAssertTrue(blueCirclePeg1.contains(boundaryPointOfBlueCirclePeg1))
    }
    func testContains_pointOutside_false() {
        XCTAssertFalse(blueCirclePeg1.contains(origin))
    }

    func testOverlaps_notOverlapping_false() {
        XCTAssertFalse(blueCirclePeg1.overlaps(with: orangeCirclePeg1))
    }
    func testOverlaps_touchingOnTheBoundary_true() {
        XCTAssertTrue(blueCirclePeg1.overlaps(with: blueCirclePeg2))
    }
    func testOverlaps_overlapping_true() {
        XCTAssertTrue(orangeCirclePeg1.overlaps(with: orangeCirclePeg2))
    }

    func testOffSetBy() {
        XCTAssertEqual(blueCirclePeg1.offsetBy(x: 0, y: 0), sameBlueCirclePeg1)
        XCTAssertEqual(blueCirclePeg1.offsetBy(x: 40, y: 0), blueCirclePeg2)
    }

    func testMoveTo() {
        let newPosition = CGPoint(x: 505, y: 505)
        let newPeg = blueCirclePeg1.moveTo(newPosition)
        XCTAssertEqual(newPeg.center, newPosition)
        XCTAssertEqual(newPeg.color, .blue)
        XCTAssertEqual(newPeg.shape, .circle)
    }

    func testResize_negativeScale_remainUnchanged() {
        XCTAssertEqual(blueCirclePeg1.resize(by: -1), blueCirclePeg1)
        XCTAssertEqual(orangeCirclePeg1.resize(by: -10), orangeCirclePeg1)
    }
    func testResize() {
        let resized1 = blueCirclePeg1.resize(by: 2)
        XCTAssertEqual(resized1.physicsShape.radius, blueCirclePeg1.physicsShape.radius * 2)
        let resized2 = orangeCirclePeg1.resize(by: 0)
        XCTAssertEqual(resized2.physicsShape.radius, 0)
    }

    func testEqual_differentPegs_false() {
        XCTAssertNotEqual(blueCirclePeg1, orangeCirclePeg1)
        XCTAssertNotEqual(blueCirclePeg1, blueCirclePeg2)
        XCTAssertNotEqual(orangeCirclePeg1, orangeCirclePeg2)
    }
    func testEqual_samePegs_true() {
        XCTAssertEqual(blueCirclePeg1, sameBlueCirclePeg1)
        XCTAssertEqual(blueCirclePeg1, blueCirclePeg1)
    }

    func testHashValue_differentPegs_differentHashValue() {
        XCTAssertNotEqual(blueCirclePeg1.hashValue, orangeCirclePeg1.hashValue)
        XCTAssertNotEqual(blueCirclePeg1.hashValue, blueCirclePeg2.hashValue)
        XCTAssertNotEqual(orangeCirclePeg1.hashValue, orangeCirclePeg2.hashValue)
    }
    func testHashValue_samePeg_sameHashValue() {
        XCTAssertEqual(blueCirclePeg1.hashValue, sameBlueCirclePeg1.hashValue)
        XCTAssertEqual(blueCirclePeg1.hashValue, blueCirclePeg1.hashValue)
    }
}
