//
//  StorageUtility.swift
//  Peggle
//
//  Created by TFang on 28/1/21.
//

import Foundation

class StorageUtility {

    static func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    static func clearDocumentsDirectory() {
        getDocumentDirectoryFileURLs(with: "json")?
            .forEach({ try? FileManager.default.removeItem(at: $0) })
    }
    static func getFileUrl(of fileName: String) -> URL {
        let directory = StorageUtility.getDocumentsDirectory()

        return directory.appendingPathComponent(fileName).appendingPathExtension("json")
    }

    static func doesFileExist(fileName: String) -> Bool {
        guard let jsonFiles = getDocumentDirectoryFileURLs(with: "json") else {
            return false
        }

        let jsonFileNames = jsonFiles.map { $0.deletingPathExtension().lastPathComponent }

        return jsonFileNames.contains(fileName)
    }

    static func getDocumentDirectoryFileURLs(with pathExtension: String) -> [URL]? {
        let directory = StorageUtility.getDocumentsDirectory()

        guard let directoryContents = try? FileManager.default.contentsOfDirectory(
            at: directory, includingPropertiesForKeys: nil) else {
            return nil
        }
        return directoryContents.filter { $0.pathExtension == pathExtension }
    }

}
