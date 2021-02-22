//
//  Peg.swift
//  Peggle
//
//  Created by TFang on 27/1/21.
//

import CoreGraphics

struct Peg: Oscillatable {
    private(set) var shape: PegShape
    private(set) var color: PegColor
    private(set) var physicsShape: PhysicsShape

    var center: CGPoint {
        physicsShape.center
    }

    var frame: CGRect {
        physicsShape.frame
    }

    var unrotatedFrame: CGRect {
        physicsShape.unrotatedFrame
    }

    // Oscillatable Attributes
    private(set) var isOscillating: Bool
    var isGoingRightFirst: Bool
    var greenHandleLength = Constants.defaultHandleLength
    var redHandleLength = Constants.defaultHandleLength

    init(shape: PegShape, color: PegColor, physicsShape: PhysicsShape,
         isOscillating: Bool = false, isGoingRightFirst: Bool = false) {
        self.shape = shape
        self.color = color
        self.physicsShape = physicsShape

        self.isOscillating = isOscillating
        self.isGoingRightFirst = isGoingRightFirst
    }

    /// Constructs a circle peg. Returns a circle peg of radius 0 if the radius is negative.
    ///
    /// Note that peg with negative center is allowed.
    /// However, what is not allowed is that peg appearing on the game board.
    init(circlePegOfRadius: CGFloat, center: CGPoint, color: PegColor,
         isOscillating: Bool = false, isGoingRightFirst: Bool = false) {
        self.shape = .circle
        self.color = color
        self.physicsShape = PhysicsShape(circleOfRadius: circlePegOfRadius, center: center)

        self.isOscillating = isOscillating
        self.isGoingRightFirst = isGoingRightFirst
    }

    init(circlePegOfCenter: CGPoint, color: PegColor,
         isOscillating: Bool = false) {
        self.init(circlePegOfRadius: Constants.defaultCirclePegRadius,
                  center: circlePegOfCenter, color: color, isOscillating: isOscillating)
    }

    func contains(_ point: CGPoint) -> Bool {
        physicsShape.contains(point)
    }

    func moveTo(_ position: CGPoint) -> Peg {
        Peg(shape: shape, color: color, physicsShape: physicsShape.moveTo(position))
    }

    func offsetBy(x: CGFloat, y: CGFloat) -> Peg {
        moveTo(center.offsetBy(x: x, y: y))
    }

    /// Resizes this `Peg`. if the scale is negative, the Peg is unchanged.
    func resize(by scale: CGFloat) -> Peg {
        Peg(shape: shape, color: color, physicsShape: physicsShape.resize(by: scale))
    }

    /// Rotates this `Peg`.
    func rotate(by angle: CGFloat) -> Peg {
        Peg(shape: shape, color: color, physicsShape: physicsShape.rotate(by: angle))
    }
}

// MARK: Hashable
extension Peg: Hashable {
}

// MARK: Codable
extension Peg: Codable {
}
