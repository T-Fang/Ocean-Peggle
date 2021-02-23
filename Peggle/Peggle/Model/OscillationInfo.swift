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

extension OscillationInfo {
    func flipHandle() -> OscillationInfo {
        OscillationInfo(isGoingRightFirst: !isGoingRightFirst,
                        leftHandleLength: rightHandleLength,
                        rightHandleLength: leftHandleLength,
                        period: period)
    }

    func changeLeftHandleLength(to length: CGFloat) -> OscillationInfo {
        OscillationInfo(isGoingRightFirst: isGoingRightFirst,
                        leftHandleLength: length,
                        rightHandleLength: rightHandleLength,
                        period: period)
    }
    func changeRightHandleLength(to length: CGFloat) -> OscillationInfo {
        OscillationInfo(isGoingRightFirst: isGoingRightFirst,
                        leftHandleLength: leftHandleLength,
                        rightHandleLength: length,
                        period: period)
    }
}
// MARK: Hashable
extension OscillationInfo: Hashable {
}

// MARK: Codable
extension OscillationInfo: Codable {
}
