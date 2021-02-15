//
//  LevelLoaderTests.swift
//  PeggleTests
//
//  Created by TFang on 13/2/21.
//

import XCTest
@testable import Peggle

class LevelLoaderTests: XCTestCase {

    let loader = LevelLoader()
    let level1 = PeggleLevel()
    let level2 = PeggleLevel(boardSize: CGSize(width: 200, height: 200))
    let level3 = PeggleLevel(boardSize: CGSize(width: 300, height: 400))
    let level1Name = "level1"
    let level2Name = "level2"
    let level3Name = "level3"
    let pegCenter1 = CGPoint(x: 20, y: 20)
    let pegCenter2 = CGPoint(x: 100, y: 100)
    var levels = [PeggleLevel]()

    override func setUp() {
        super.setUp()
        StorageUtility.clearDocumentsDirectory()
        level1.levelName = level1Name
        level2.levelName = level2Name
        level3.levelName = level3Name

        level3.addPeg(at: pegCenter1, shape: .circle, color: .blue)
        level3.addPeg(at: pegCenter2, shape: .circle, color: .orange)

        levels = [level1, level2, level3]

        levels.forEach { level in
            let fileUrl = StorageUtility.getFileUrl(of: level.levelName ?? "")
            try? JSONEncoder().encode(level).write(to: fileUrl)
        }
    }

    func testLevelCount() {
        XCTAssertEqual(loader.levelCount, 3)
        StorageUtility.clearDocumentsDirectory()
        XCTAssertEqual(loader.levelCount, 0)
    }

    func testGetLevelName_invalidIndex_returnNil() {
        XCTAssertNil(loader.getLevelName(at: 3))
        XCTAssertNil(loader.getLevelName(at: -1))
    }
    func testGetLevelName_validIndex_success() {
        XCTAssertEqual(loader.getLevelName(at: 0), level1Name)
        XCTAssertEqual(loader.getLevelName(at: 2), level3Name)
    }

    func testGetLevel_invalidIndex_returnNil() {
        XCTAssertNil(loader.getLevel(at: 3))
        XCTAssertNil(loader.getLevel(at: -1))
    }
    func testGetLevel_validIndex_success() throws {
        XCTAssertNotNil(loader.getLevel(at: 0))
        let level = try XCTUnwrap(loader.getLevel(at: 2))
        XCTAssertEqual(level.levelName, level3Name)
        XCTAssertEqual(level.pegs.count, 2)
    }

}
