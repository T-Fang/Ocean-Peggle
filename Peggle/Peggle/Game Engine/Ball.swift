//
//  Ball.swift
//  Peggle
//
//  Created by TFang on 10/2/21.
//

import CoreGraphics
class Ball: MovablePhysicsObject {
    init(center: CGPoint, angle: CGFloat, speed: CGFloat = Constants.initialBallSpeed,
         acceleration: CGVector = Constants.initialAcceleration) {
        super.init(physicsShape: PhysicsShape(circleOfRadius: Constants.ballRadius, center: center))
        updateVelocity(speed: speed, angle: angle)
        self.acceleration = acceleration
    }
}
