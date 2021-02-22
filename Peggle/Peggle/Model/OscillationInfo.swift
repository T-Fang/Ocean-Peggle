//
//  OscillationInfo.swift
//  Peggle
//
//  Created by TFang on 23/2/21.
//
import CoreGraphics

struct OscillationInfo {
    var isGoingRightFirst: Bool = false
    var leftHandleLength: CGFloat = Constants.defaultHandleLength
    var rightHandleLength: CGFloat = Constants.defaultHandleLength
    var period: CGFloat = .zero
}

// MARK: Hashable
extension OscillationInfo: Hashable {
}

// MARK: Codable
extension OscillationInfo: Codable {
}
