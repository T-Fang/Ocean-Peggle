//
//  Block.swift
//  Peggle
//
//  Created by TFang on 21/2/21.
//

import CoreGraphics

struct Block: PeggleObject {
    private(set) var physicsShape: PhysicsShape

    // Oscillatable Attributes
    var isOscillating: Bool
    var isGoingRightFirst: Bool
    var greenHandleLength = Constants.defaultHandleLength
    var redHandleLength = Constants.defaultHandleLength

    private init(physicsShape: PhysicsShape,
                 isOscillating: Bool, isGoingRightFirst: Bool) {
        self.physicsShape = physicsShape
        self.isOscillating = isOscillating
        self.isGoingRightFirst = isGoingRightFirst
    }
    init(size: CGSize, center: CGPoint,
         isOscillating: Bool = false, isGoingRightFirst: Bool = false) {
        self.physicsShape = PhysicsShape(rectOfSize: size, center: center)

        self.isOscillating = isOscillating
        self.isGoingRightFirst = isGoingRightFirst
    }

    func changeShape(to physicsShape: PhysicsShape) -> Block {
        Block(physicsShape: physicsShape,
              isOscillating: isOscillating, isGoingRightFirst: isGoingRightFirst)
    }
}

// MARK: Hashable
extension Block: Hashable {
}

// MARK: Codable
extension Block: Codable {
}
