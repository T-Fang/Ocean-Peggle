//
//  Ball.swift
//  Peggle
//
//  Created by TFang on 10/2/21.
//

import CoreGraphics
class Ball: MovablePhysicsObject {
    init(center: CGPoint) {
        super.init(physicsShape: PhysicsShape(circleOfRadius: Constants.ballRadius, center: center))
    }
}
