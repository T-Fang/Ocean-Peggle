//
//  LevelSaverTests.swift
//  PeggleTests
//
//  Created by TFang on 13/2/21.
//

import XCTest
@testable import Peggle

class LevelSaverTests: XCTestCase {

    let level1 = PeggleLevel()
    let level2 = PeggleLevel(boardSize: CGSize(width: 200, height: 200))
    let level3 = PeggleLevel(boardSize: CGSize(width: 300, height: 400))
    let level1Name = "level1"
    let level2Name = "level2"
    let level3Name = "level3"
    let pegCenter1 = CGPoint(x: 20, y: 20)
    let pegCenter2 = CGPoint(x: 100, y: 100)

    override func setUp() {
        super.setUp()
        StorageUtility.clearDocumentsDirectory()
        level1.levelName = level1Name
        level2.levelName = level2Name
        level3.levelName = level3Name

        level3.addPeg(at: pegCenter1, shape: .circle, color: .blue)
        level3.addPeg(at: pegCenter2, shape: .circle, color: .orange)
    }

    func testSaveLevel() {
        XCTAssertTrue(LevelSaver.saveLevel(peggleLevel: level1, fileName: level1Name))
        XCTAssertTrue(LevelSaver.saveLevel(peggleLevel: level3, fileName: level3Name))
        XCTAssertEqual(2, StorageUtility.getDocumentDirectoryFileURLs(with: "json")?.count)
    }

    func testDeleteLevel_levelNameDoesNotExist() {
        XCTAssertTrue(LevelSaver.saveLevel(peggleLevel: level3, fileName: level3Name))
        LevelSaver.deleteLevel(levelName: "someRandomName")
        XCTAssertEqual(1, StorageUtility.getDocumentDirectoryFileURLs(with: "json")?.count)
    }
    func testDeleteLevel() {
        XCTAssertTrue(LevelSaver.saveLevel(peggleLevel: level1, fileName: level1Name))
        XCTAssertTrue(LevelSaver.saveLevel(peggleLevel: level2, fileName: level2Name))
        XCTAssertTrue(LevelSaver.saveLevel(peggleLevel: level3, fileName: level3Name))
        LevelSaver.deleteLevel(levelName: level3Name)
        XCTAssertEqual(2, StorageUtility.getDocumentDirectoryFileURLs(with: "json")?.count)
        LevelSaver.deleteLevel(levelName: level1Name)
        LevelSaver.deleteLevel(levelName: level2Name)
        XCTAssertEqual(0, StorageUtility.getDocumentDirectoryFileURLs(with: "json")?.count)
    }

}
