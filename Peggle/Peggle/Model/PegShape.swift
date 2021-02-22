//
//  PegShape.swift
//  Peggle
//
//  Created by TFang on 9/2/21.
//

enum PegShape: String, CaseIterable {
    case circle
}

// MARK: Hashable
extension PegShape: Hashable {
}

// MARK: Codable
extension PegShape: Codable {
}
