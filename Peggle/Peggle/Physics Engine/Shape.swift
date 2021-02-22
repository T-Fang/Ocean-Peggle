//
//  Shape.swift
//  Peggle
//
//  Created by TFang on 9/2/21.
//

enum Shape: String {
    case circle
    case rectangle
}

// MARK: Hashable
extension Shape: Hashable {
}

// MARK: Codable
extension Shape: Codable {
}
