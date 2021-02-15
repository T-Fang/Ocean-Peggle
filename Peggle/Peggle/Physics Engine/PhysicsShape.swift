//
//  PhysicsShape.swift
//  Peggle
//
//  Created by TFang on 9/2/21.
//

import CoreGraphics

/// `PhysicsShape` represent shapes in a physics world,
/// it can represent a circle or a polygon
struct PhysicsShape {

    let shape: Shape
    var center: CGPoint
    let rotation: CGFloat

    // property for circle
    let radius: CGFloat
    // property for polygon
    let vertices: [CGPoint]

    /// a rectangular frame that surrounds this `PhysicsShape`
    var frame: CGRect {
        switch shape {
        case .circle:
            let origin = CGPoint(x: center.x - radius, y: center.y - radius)
            let size = CGSize(width: radius * 2, height: radius * 2)
            return CGRect(origin: origin, size: size)
        }
    }

    /// Constructs a circle `PhysicsShape`.
    /// Returns a circle of radius 0 if the radius is negative.
    init(circleOfRadius: CGFloat, center: CGPoint) {

        self.shape = .circle
        self.center = center
        self.rotation = CGFloat.zero
        self.vertices = []
        guard circleOfRadius >= 0 else {
            self.radius = CGFloat.zero
            return
        }
        self.radius = circleOfRadius
    }

    /// Resizes this `PhysicsShape`. if the scale is negative, the shape is unchanged.
    func resize(by scale: CGFloat) -> PhysicsShape {
        guard scale >= 0 else {
            return self
        }
        switch shape {
        case .circle:
            return PhysicsShape(circleOfRadius: radius * scale, center: center)
        }
    }
    func overlaps(with physicsShape: PhysicsShape) -> Bool {
        switch shape {
        case .circle:
            switch physicsShape.shape {
            case .circle:
                return center.distanceTo(physicsShape.center) <= radius + physicsShape.radius
            }
        }
    }

    func contains(_ point: CGPoint) -> Bool {
        switch shape {
        case .circle:
            return center.distanceTo(point) <= radius
        }
    }

    func moveTo(_ position: CGPoint) -> PhysicsShape {
        switch shape {
        case .circle:
            return PhysicsShape(circleOfRadius: radius, center: position)
        }
    }
    func rotate(by angle: CGFloat) -> PhysicsShape {
        switch shape {
        case .circle:
            return self
        }
    }
}

// MARK: Hashable
extension PhysicsShape: Hashable {
}

// MARK: Codable
extension PhysicsShape: Codable {
}
