//
//  Peg.swift
//  Peggle
//
//  Created by TFang on 27/1/21.
//

import CoreGraphics

struct Peg: PeggleObject {

    private(set) var shape: PegShape
    private(set) var color: PegColor
    private(set) var physicsShape: PhysicsShape

    // Oscillatable Attributes
    var oscillationInfo: OscillationInfo?

    private init(shape: PegShape, color: PegColor, physicsShape: PhysicsShape,
                 oscillationInfo: OscillationInfo?) {
        self.shape = shape
        self.color = color
        self.physicsShape = physicsShape

        self.oscillationInfo = oscillationInfo
    }

    /// Constructs a circle peg. Returns a circle peg of radius 0 if the radius is negative.
    ///
    /// Note that peg with negative center is allowed.
    /// However, what is not allowed is that peg appearing on the game board.
    init(circlePegOfRadius: CGFloat, center: CGPoint, color: PegColor,
         period: CGFloat? = nil) {
        self.shape = .circle
        self.color = color
        self.physicsShape = PhysicsShape(circleOfRadius: circlePegOfRadius, center: center)

        if let period = period {
            self.oscillationInfo = OscillationInfo(period: period)
        }
    }

    init(circlePegOfCenter: CGPoint, color: PegColor,
         period: CGFloat? = nil) {
        self.init(circlePegOfRadius: Constants.defaultCirclePegRadius,
                  center: circlePegOfCenter, color: color, period: period)
    }

    func changeShape(to physicsShape: PhysicsShape) -> Peg {
        Peg(shape: shape, color: color, physicsShape: physicsShape, oscillationInfo: oscillationInfo)
    }

    func changeInfo(to info: OscillationInfo) -> Peg {
        Peg(shape: shape, color: color, physicsShape: physicsShape, oscillationInfo: info)
    }
}

// MARK: Hashable
extension Peg: Hashable {
}

// MARK: Codable
extension Peg: Codable {
}
