//
//  LevelLoader.swift
//  Peggle
//
//  Created by TFang on 28/1/21.
//

import Foundation

class LevelLoader {
    private var dataURLs: [URL] {
        StorageUtility.getDocumentDirectoryFileURLs(with: "json")?
            .sorted(by: { $0.deletingPathExtension().lastPathComponent
                        < $1.deletingPathExtension().lastPathComponent }) ?? []
    }

    var levelCount: Int {
        dataURLs.count
    }

    func getLevelName(at index: Int) -> String? {
        guard dataURLs.indices.contains(index) else {
            return nil
        }

        let url = dataURLs[index]
        return url.deletingPathExtension().lastPathComponent
    }

    func getLevel(at index: Int) -> PeggleLevel? {
        guard dataURLs.indices.contains(index) else {
            return nil
        }

        let url = dataURLs[index]
        return loadLevel(from: url)
    }

    private func loadLevel(from url: URL) -> PeggleLevel? {
        let gameLevelFromJsonData = try? JSONDecoder().decode(PeggleLevel.self, from: Data(contentsOf: url))
        return gameLevelFromJsonData?.scaleToFitScreen()
    }
}
