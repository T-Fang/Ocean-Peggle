//
//  Block.swift
//  Peggle
//
//  Created by TFang on 21/2/21.
//

import CoreGraphics

struct Block: Oscillatable {
    private(set) var physicsShape: PhysicsShape

    // Oscillatable Attributes
    var isOscillating: Bool
    var isGoingRightFirst: Bool
    var greenHandleLength = Constants.defaultHandleLength
    var redHandleLength = Constants.defaultHandleLength

    init(size: CGSize, center: CGPoint,
         isOscillating: Bool = false, isGoingRightFirst: Bool = false) {
        self.physicsShape = PhysicsShape(rectOfSize: size, center: center)

        self.isOscillating = isOscillating
        self.isGoingRightFirst = isGoingRightFirst
    }
}

// MARK: Hashable
extension Block: Hashable {
}

// MARK: Codable
extension Block: Codable {
}
