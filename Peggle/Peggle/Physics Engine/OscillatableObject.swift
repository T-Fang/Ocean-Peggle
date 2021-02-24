//
//  OscillatableObject.swift
//  Peggle
//
//  Created by TFang on 20/2/21.
//

import CoreGraphics

class OscillatableObject: MovablePhysicsObject {

    var period: CGFloat
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
        self.phase = amplitude > 0 ? asin(initialDisplacement / amplitude) : .zero
        super.init(physicsShape: physicsShape)
    }

    override func move() {
        guard amplitude > 0, period > 0 else {
            return
        }
        time += 1
    }
}
