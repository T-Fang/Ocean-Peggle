//
//  Peg.swift
//  Peggle
//
//  Created by TFang on 27/1/21.
//

import CoreGraphics

struct Peg {
    private(set) var shape: PegShape
    private(set) var color: PegColor
    private(set) var physicsShape: PhysicsShape

    var center: CGPoint {
        physicsShape.center
    }

    var frame: CGRect {
        physicsShape.frame
    }

    init(shape: PegShape, color: PegColor, physicsShape: PhysicsShape) {
        self.shape = shape
        self.color = color
        self.physicsShape = physicsShape
    }

    /// Constructs a circle peg. Returns a circle peg of radius 0 if the radius is negative.
    ///
    /// Note that peg with negative center is allowed.
    /// However, what is not allowed is that peg appearing on the game board.
    init(circlePegOfRadius: CGFloat, center: CGPoint, color: PegColor) {
        self.shape = .circle
        self.color = color
        self.physicsShape = PhysicsShape(circleOfRadius: circlePegOfRadius, center: center)
    }

    init(circlePegOfCenter: CGPoint, color: PegColor) {
        self.init(circlePegOfRadius: Constants.defaultCirclePegRadius,
                  center: circlePegOfCenter, color: color)
    }

    func contains(_ point: CGPoint) -> Bool {
        physicsShape.contains(point)
    }

    func overlaps(with peg: Peg) -> Bool {
        physicsShape.overlaps(with: peg.physicsShape)
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
}

// MARK: Hashable
extension Peg: Hashable {
}

// MARK: Codable
extension Peg: Codable {
}
