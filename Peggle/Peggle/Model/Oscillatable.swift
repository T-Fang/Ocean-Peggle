//
//  Oscillatable.swift
//  Peggle
//
//  Created by TFang on 22/2/21.
//

import CoreGraphics

protocol Oscillatable {
    var physicsShape: PhysicsShape { get }
    var isOscillating: Bool { get }
    var isGoingRightFirst: Bool { get set }
    var greenHandleLength: CGFloat { get set }
    var redHandleLength: CGFloat { get set }
}

extension Oscillatable {
    var initialDirection: CGVector {
        if isGoingRightFirst {
            return CGVector.generateVector(from: physicsShape.center, to: physicsShape.rightMidPoint)
        } else {
            return CGVector.generateVector(from: physicsShape.center, to: physicsShape.leftMidPoint)
        }
    }

    var greenHandlePosition: CGPoint {
        if isGoingRightFirst {
            return physicsShape.rightMidPoint.offset(by: initialDirection.normalized().scale(by: greenHandleLength))
        } else {
            return physicsShape.leftMidPoint.offset(by: initialDirection.normalized().scale(by: greenHandleLength))
        }
    }

    var redHandlePosition: CGPoint {
        if isGoingRightFirst {
            return physicsShape.leftMidPoint.offset(by: initialDirection.normalized().scale(by: -redHandleLength))
        } else {
            return physicsShape.rightMidPoint.offset(by: initialDirection.normalized().scale(by: -redHandleLength))
        }
    }

    var greenHandleArea: PhysicsShape {
        PhysicsShape(circleOfRadius: Constants.defaultHandleRadius, center: greenHandlePosition)
    }

    var redHandleArea: PhysicsShape {
        PhysicsShape(circleOfRadius: Constants.defaultHandleRadius, center: redHandlePosition)
    }

    /// - Returns: a rectangle shape the surrounds the area that this object will go through.
    ///            the orginial physics shape is returned if the object is static
    var areaShape: PhysicsShape {
        guard isOscillating else {
            return physicsShape
        }
        let width = 2 * Constants.defaultHandleRadius
            + greenHandlePosition.distanceTo(redHandlePosition)
        let height = physicsShape.unrotatedFrame.height
        let size = CGSize(width: width, height: height)

        return PhysicsShape(rectOfSize: size,
                            center: greenHandlePosition.midpoint(with: redHandlePosition),
                            rotation: physicsShape.rotation)
    }

}
