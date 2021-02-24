//
//  Wall.swift
//  Peggle
//
//  Created by TFang on 24/2/21.
//

import CoreGraphics

class Wall: PhysicsObject {
    let type: WallType
    init(frame: CGRect, type: WallType) {
        self.type = type
        super.init(physicsShape: PhysicsShape(rectOfSize: frame.size,
                                              center: CGPoint(x: frame.midX, y: frame.midY)))
    }
}

enum WallType {
    case leftWall
    case rightWall
    case topWall
    case bottomWall
}
