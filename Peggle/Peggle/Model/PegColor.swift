//
//  PegColor.swift
//  Peggle
//
//  Created by TFang on 9/2/21.
//

enum PegColor: String, CaseIterable {
    case blue
    case orange
    case green
}

// MARK: Hashable
extension PegColor: Hashable {
}

// MARK: Codable
extension PegColor: Codable {
}
