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

    func changeInfo(to info: OscillationInfo) -> Self
}

extension Oscillatable {
    var period: CGFloat {
        oscillationInfo?.period ?? .zero
    }
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
            .offset(by: vectorTowardRight.normalized.scale(by: oscillationInfo?.rightHandleLength ?? 0))
    }
    var leftHandlePosition: CGPoint {
        physicsShape.leftMidPoint
            .offset(by: vectorTowardLeft.normalized.scale(by: oscillationInfo?.leftHandleLength ?? 0))
    }
    var movementCenter: CGPoint {
        rightHandlePosition.midpoint(with: leftHandlePosition)
    }
    var leftArrowLength: CGFloat {
        physicsShape.center.distanceTo(leftHandlePosition)
    }
    var amplitude: CGFloat {
        leftArrowLength + rightArrowLength
    }
    var rightArrowLength: CGFloat {
        physicsShape.center.distanceTo(rightHandlePosition)
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
        PhysicsShape(circleOfRadius: Constants.handleTouchableRadius, center: greenHandlePosition)
    }

    var redHandleArea: PhysicsShape {
        PhysicsShape(circleOfRadius: Constants.handleTouchableRadius, center: redHandlePosition)
    }

    /// - Returns: a rectangle shape the surrounds the area that this object will go through.
    ///            the orginial physics shape is returned if the object is static
    var areaShape: PhysicsShape {
        guard oscillationInfo != nil else {
            return physicsShape
        }
        var width = 2 * Constants.defaultHandleRadius
            + greenHandlePosition.distanceTo(redHandlePosition)
        width = max(width, physicsShape.unrotatedFrame.height)
        let height = physicsShape.unrotatedFrame.height
        let size = CGSize(width: width, height: height)

        return PhysicsShape(rectOfSize: size,
                            center: movementCenter,
                            rotation: physicsShape.rotation)
    }

    func handleContains(_ point: CGPoint) -> Bool {
        guard oscillationInfo != nil else {
            return false
        }

        return redHandleArea.contains(point)
            || greenHandleArea.contains(point)
    }

    func flipHandle() -> Self {
        guard let info = oscillationInfo else {
            return self
        }
        return changeInfo(to: info.flipHandle())
    }

    func isPointOnTheRight(_ point: CGPoint) -> Bool {
        let centerToPoint = CGVector.generateVector(from: physicsShape.center, to: point)
        return vectorTowardRight.dotProduct(with: centerToPoint) >= 0
    }

    func changeHandleLength(to length: CGFloat, isRightHandle: Bool) -> Self {
        guard let info = oscillationInfo else {
            return self
        }

        let newInfo = isRightHandle ? info.changeRightHandleLength(to: length)
            : info.changeLeftHandleLength(to: length)
        return changeInfo(to: newInfo)
    }
}
