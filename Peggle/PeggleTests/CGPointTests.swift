//
//  CGPointTests.swift
//  PeggleTests
//
//  Created by TFang on 30/1/21.
//

import XCTest
@testable import Peggle

class CGPointTests: XCTestCase {

    let origin = CGPoint(x: 0, y: 0)
    let O = CGPoint(x: 0, y: 0)
    let A = CGPoint(x: 3, y: 4)
    let B = CGPoint(x: 5, y: 12)
    let C = CGPoint(x: 8, y: 16)
    let OA = CGFloat(5)
    let OB = CGFloat(13)
    let BC = CGFloat(5)
    let pi = CGFloat(Double.pi)

    let tolerableRotateError: CGFloat = 0.000_000_000_001
    private func withinTolerableError(expected: CGPoint, actual: CGPoint) -> Bool {
        let isXOk = expected.x - tolerableRotateError <= actual.x
            && expected.x + tolerableRotateError >= actual.x
        let isYOk = expected.y - tolerableRotateError <= actual.y
            && expected.y + tolerableRotateError >= actual.y
        return isXOk && isYOk
    }

    func testDistanceTo_distanceToAPointItself_zero() {
        XCTAssertEqual(O.distanceTo(O), CGFloat(0))
        XCTAssertEqual(A.distanceTo(A), CGFloat(0))
    }

    func testDistanceTo_differentPoints() {
        XCTAssertEqual(O.distanceTo(A), OA)
        XCTAssertEqual(O.distanceTo(B), OB)
        XCTAssertEqual(C.distanceTo(B), BC)
    }

    func testOffsetBy_zero_samePoint() {
        XCTAssertEqual(O.offsetBy(x: 0, y: 0), O)
        XCTAssertEqual(A.offsetBy(x: 0, y: 0), A)
    }

    func testOffsetBy_negativeValue_success() {
        XCTAssertEqual(B.offsetBy(x: -2, y: -8), A)
        XCTAssertEqual(C.offsetBy(x: -3, y: -4), B)
    }

    func testOffsetBy_positiveValue_success() {
        XCTAssertEqual(O.offsetBy(x: 3, y: 4), A)
        XCTAssertEqual(A.offsetBy(x: 5, y: 12), C)
    }

    func testRotate_rotateAroundPointItself_samePoint() {
        let point1 = O.rotate(around: O, by: pi)
        XCTAssertEqual(point1, O)
        let point2 = A.rotate(around: A, by: pi / 2)
        XCTAssertEqual(point2, A)
    }

    func testRotate_angleIsZero_samePoint() {
        let point1 = O.rotate(around: A, by: 0)
        XCTAssertEqual(point1, O)
        let point2 = A.rotate(around: B, by: 0)
        XCTAssertEqual(point2, A)
    }

    func testRotate_positiveAngle_success() {
        let point1 = A.rotate(around: O, by: pi)

        XCTAssertTrue(withinTolerableError(expected: CGPoint(x: -A.x, y: -A.y),
                                           actual: point1))
        let point2 = B.rotate(around: O, by: pi / 2)
        XCTAssertTrue(withinTolerableError(expected: CGPoint(x: -B.y, y: B.x), actual: point2))
    }

    func testRotate_negativeAngle_success() {
        let point2 = B.rotate(around: O, by: -pi / 2)
        XCTAssertTrue(withinTolerableError(expected: CGPoint(x: B.y, y: -B.x), actual: point2))
    }

    func testEqual_SamePoint_equal() {
        XCTAssertEqual(O, O)
        XCTAssertEqual(A, A)
        XCTAssertEqual(O, origin)
    }

    func testNotEqual_differentPoints_notEqual() {
        XCTAssertNotEqual(O, A)
        XCTAssertNotEqual(A, B)
    }

    func testHashValue_samePoint_sameHashValue() {
        XCTAssertEqual(O.hashValue, O.hashValue)
        XCTAssertEqual(A.hashValue, A.hashValue)
        XCTAssertEqual(O.hashValue, origin.hashValue)
    }

    func testHashValue_differentPoints_differentHashValue() {
        XCTAssertNotEqual(O.hashValue, A.hashValue)
        XCTAssertNotEqual(A.hashValue, B.hashValue)
    }
}
