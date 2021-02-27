//
//  PeggleObject.swift
//  Peggle
//
//  Created by TFang on 22/2/21.
//

import CoreGraphics

protocol PeggleObject: Oscillatable {
    func changeShape(to physicsShape: PhysicsShape) -> Self
}

extension PeggleObject {
    var center: CGPoint {
        physicsShape.center
    }

    var unrotatedFrame: CGRect {
        physicsShape.unrotatedFrame
    }

    func overlaps(with object: PeggleObject) -> Bool {
        physicsShape.overlaps(with: object.physicsShape)
    }

    func contains(_ point: CGPoint) -> Bool {
        physicsShape.contains(point)
    }

    func moveTo(_ position: CGPoint) -> Self {
        changeShape(to: physicsShape.moveTo(position))
    }
    func offsetBy(x: CGFloat, y: CGFloat) -> Self {
        moveTo(center.offsetBy(x: x, y: y))
    }
    func rotate(by angle: CGFloat) -> Self {
        changeShape(to: physicsShape.rotate(by: angle))
    }
    /// Resizes this object. if the scale is negative, the object is unchanged.
    func resize(by scale: CGFloat) -> Self {
        changeShape(to: physicsShape.resize(by: scale))
    }
    func resizeShapeAndHandle(by scale: CGFloat) -> Self {
        resize(by: scale).resizeHandle(by: scale)
    }
}
