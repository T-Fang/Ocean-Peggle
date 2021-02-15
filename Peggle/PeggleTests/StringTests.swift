//
//  StringTests.swift
//  PeggleTests
//
//  Created by TFang on 30/1/21.
//

import XCTest
@testable import Peggle

class StringTests: XCTestCase {
    let emptyString = ""
    let validString1 = "HelloWorld123"
    let validString2 = "1"
    let validString3 = "A"
    let invalidString1 = "Hello Wolrd"
    let invalidString2 = "HelloWolrd!"
    let invalidString3 = "?"

    func testIsAlphanumeric_emptyString_false() {
        XCTAssertFalse(emptyString.isAlphanumeric())
    }

    func testIsAlphanumeric_validString_true() {
        XCTAssertTrue(validString1.isAlphanumeric())
        XCTAssertTrue(validString2.isAlphanumeric())
        XCTAssertTrue(validString3.isAlphanumeric())
    }

    func testIsAlphanumeric_invalidString_false() {
        XCTAssertFalse(invalidString1.isAlphanumeric())
        XCTAssertFalse(invalidString2.isAlphanumeric())
        XCTAssertFalse(invalidString3.isAlphanumeric())
    }

}
