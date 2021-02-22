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
    var oscillationInfo: OscillationInfo?

    private init(physicsShape: PhysicsShape, oscillationInfo: OscillationInfo?) {
        self.physicsShape = physicsShape
        self.oscillationInfo = oscillationInfo
    }

    init(size: CGSize, center: CGPoint, period: CGFloat? = nil) {
        self.physicsShape = PhysicsShape(rectOfSize: size, center: center)

        if let period = period {
            self.oscillationInfo = OscillationInfo(period: period)
        }
    }

    func changeShape(to physicsShape: PhysicsShape) -> Block {
        Block(physicsShape: physicsShape, oscillationInfo: oscillationInfo)
    }
}

// MARK: Hashable
extension Block: Hashable {
}

// MARK: Codable
extension Block: Codable {
}
