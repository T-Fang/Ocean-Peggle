//
//  PhysicsObject.swift
//  Peggle
//
//  Created by TFang on 9/2/21.
//

import CoreGraphics

/// `PhysicsObject` class represents a 2D object.
/// Note that there can be multiple objects with same attributes in a 2D world.
/// Therefore, it is set as a class without == implementation
class PhysicsObject {

    var physicsShape: PhysicsShape

    var center: CGPoint {
        get {
            physicsShape.center
        }
        set {
            physicsShape = physicsShape.moveTo(newValue)
        }
    }

    // a rectangular frame that surrounds this `PhysicsObject`
    var frame: CGRect {
        physicsShape.frame
    }

    init(physicsShape: PhysicsShape) {
        self.physicsShape = physicsShape
    }

    func overlaps(with physicsBody: PhysicsObject) -> Bool {
        physicsShape.overlaps(with: physicsBody.physicsShape)
    }
}
