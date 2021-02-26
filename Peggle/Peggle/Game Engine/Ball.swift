//
//  Ball.swift
//  Peggle
//
//  Created by TFang on 10/2/21.
//

import CoreGraphics
class Ball: MovablePhysicsObject {
    private(set) var isFloating: Bool = false

    init(center: CGPoint, angle: CGFloat, speed: CGFloat = Constants.initialBallSpeed,
         acceleration: CGVector = Constants.gravitationalAcceleration) {
        super.init(physicsShape: PhysicsShape(circleOfRadius: Constants.ballRadius, center: center))
        updateVelocity(speed: speed, angle: angle)
        self.acceleration = acceleration
    }

    func float() {
        isFloating = true
        acceleration = Constants.floatingAcceleration
    }

    func unfloat() {
        isFloating = false
        acceleration = Constants.gravitationalAcceleration
    }
}
