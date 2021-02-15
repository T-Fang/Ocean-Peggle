//
//  LevelSaver.swift
//  Peggle
//
//  Created by TFang on 30/1/21.
//

import Foundation

class LevelSaver {

    static func saveLevel(peggleLevel: PeggleLevel, fileName: String) -> Bool {
        peggleLevel.levelName = fileName
        let fileUrl = StorageUtility.getFileUrl(of: fileName)
        guard (try? JSONEncoder().encode(peggleLevel).write(to: fileUrl)) != nil else {
            return false
        }
        return true
    }

    static func deleteLevel(levelName: String) {
        let filePath = StorageUtility.getFileUrl(of: levelName)
        try? FileManager.default.removeItem(at: filePath)
    }

}
