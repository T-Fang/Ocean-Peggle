//
//  Oscillatable.swift
//  Peggle
//
//  Created by TFang on 22/2/21.
//

import CoreGraphics

protocol Oscillatable {
    var physicsShape: PhysicsShape { get }
    var oscillationInfo: OscillationInfo? { get set }
}

extension Oscillatable {
    var vectorTowardRight: CGVector {
        CGVector.generateVector(from: physicsShape.center, to: physicsShape.rightMidPoint)
    }
    var vectorTowardLeft: CGVector {
        CGVector.generateVector(from: physicsShape.center, to: physicsShape.leftMidPoint)
    }
    var initialDirection: CGVector {
        if oscillationInfo?.isGoingRightFirst == true {
            return vectorTowardRight
        } else {
            return vectorTowardLeft
        }
    }
    var rightHandlePosition: CGPoint {
        physicsShape.rightMidPoint
            .offset(by: vectorTowardRight.normalized().scale(by: oscillationInfo?.rightHandleLength ?? 0))
    }
    var leftHandlePosition: CGPoint {
        physicsShape.leftMidPoint
            .offset(by: vectorTowardLeft.normalized().scale(by: oscillationInfo?.leftHandleLength ?? 0))
    }
    var movementCenter: CGPoint {
        rightHandlePosition.midpoint(with: leftHandlePosition)
    }
    var leftArrowLength: CGFloat {
        movementCenter.distanceTo(leftHandlePosition)
    }
    var rightArrowLength: CGFloat {
        movementCenter.distanceTo(rightHandlePosition)
    }
    var greenHandlePosition: CGPoint {
        if oscillationInfo?.isGoingRightFirst == true {
            return rightHandlePosition
        } else {
            return leftHandlePosition
        }
    }
    var redHandlePosition: CGPoint {
        if oscillationInfo?.isGoingRightFirst == true {
            return leftHandlePosition
        } else {
            return rightHandlePosition
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
        guard oscillationInfo != nil else {
            return physicsShape
        }
        var width = 2 * Constants.defaultHandleRadius
            + greenHandlePosition.distanceTo(redHandlePosition)
        width = max(width, physicsShape.bounds.height)
        let height = physicsShape.bounds.height
        let size = CGSize(width: width, height: height)

        return PhysicsShape(rectOfSize: size,
                            center: movementCenter,
                            rotation: physicsShape.rotation)
    }

}
