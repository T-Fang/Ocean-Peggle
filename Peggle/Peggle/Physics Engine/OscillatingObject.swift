//
//  OscillatingObject.swift
//  Peggle
//
//  Created by TFang on 20/2/21.
//

import CoreGraphics

class OscillatingObject: MovablePhysicsObject {
    let period: CGFloat
    let initialDirection: CGVector
    let amplitude: CGFloat
    let phase: CGFloat
    let movementCenter: CGPoint

    private var time = CGFloat.zero {
        didSet {
            // based on 60Hz refresh rate
            let newDisplacement = amplitude * sin(CGFloat.pi / (30 * period) * time + phase)
            let newPosition = movementCenter
                .offset(by: initialDirection.normalized.scale(by: newDisplacement))
            physicsShape = physicsShape.moveTo(newPosition)
        }
    }

    init(physicsShape: PhysicsShape, period: CGFloat, initialDirection: CGVector,
         amplitude: CGFloat, movementCenter: CGPoint) {
        self.period = period
        self.initialDirection = initialDirection
        self.amplitude = amplitude
        self.movementCenter = movementCenter
        let initialDisplacement = CGVector
            .generateVector(from: movementCenter, to: physicsShape.center)
            .componentOn(initialDirection)
        self.phase = asin(initialDisplacement / amplitude)
        super.init(physicsShape: physicsShape)
    }

    override func move() {
        time += 1
    }
}
