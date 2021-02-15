//
//  CGVectorTests.swift
//  PeggleTests
//
//  Created by TFang on 13/2/21.
//

import XCTest
@testable import Peggle

class CGVectorTests: XCTestCase {
    let zeroVector = CGVector.zero
    let vector1 = CGVector(dx: 3, dy: 4)
    let negativeVector1 = CGVector(dx: -3, dy: -4)
    let vectorOnXAxis = CGVector(dx: -5, dy: 0)
    let vectorOnYAxis = CGVector(dx: 0, dy: 2)

    func testReflectAlong_axisIsVectorItself_negateTheVector() {
        XCTAssertEqual(negativeVector1, vector1.reflectAlong(axis: vector1))
        XCTAssertEqual(zeroVector, zeroVector.reflectAlong(axis: zeroVector))
    }

    func testReflectAlong_axisIsZeroVector_sameVector() {
        XCTAssertEqual(vector1, vector1.reflectAlong(axis: zeroVector))
        XCTAssertEqual(vectorOnXAxis, vectorOnXAxis.reflectAlong(axis: zeroVector))
    }

    func testReflectAlong() {
        XCTAssertEqual(CGVector(dx: -vector1.dx, dy: vector1.dy),
                       vector1.reflectAlong(axis: vectorOnXAxis))
        XCTAssertEqual(CGVector(dx: vector1.dx, dy: -vector1.dy),
                       vector1.reflectAlong(axis: vectorOnYAxis))
    }

    func testAdd_addZero_sameVector() {
        XCTAssertEqual(vector1.add(zeroVector), vector1)
        XCTAssertEqual(zeroVector.add(zeroVector), zeroVector)
    }

    func testAdd() {
        XCTAssertEqual(vector1.add(negativeVector1), zeroVector)
        XCTAssertEqual(vector1.add(vectorOnXAxis), CGVector(dx: -2, dy: 4))
    }
}
