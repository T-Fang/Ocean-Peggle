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
    // property for polygon. Vertices are arranged in clockwise direction
    let vertices: [CGPoint]

    /// a rectangular frame that surrounds this `PhysicsShape`
    var frame: CGRect {
        switch shape {
        case .circle:
            let origin = center.offsetBy(x: -radius, y: -radius)
            let size = CGSize(width: radius * 2, height: radius * 2)
            return CGRect(origin: origin, size: size)
        default:
            // polygon
            let sortedX = vertices.map({ $0.x }).sorted()
            let sortedY = vertices.map({ $0.y }).sorted()
            guard let minX = sortedX.first,
                  let maxX = sortedX.last,
                  let minY = sortedY.first,
                  let maxY = sortedY.last else {
                return .zero
            }

            let width = maxX - minX
            let height = maxY - minY
            let origin = CGPoint(x: minX, y: minY)
            return CGRect(origin: origin, size: CGSize(width: width, height: height))
        }
    }

    var leftMidPoint: CGPoint {
        let unrotatedLeftMidPoint = CGPoint(x: unrotatedFrame.minX, y: unrotatedFrame.midY)
        switch shape {
        case .circle:
        return unrotatedLeftMidPoint.rotate(around: center, by: rotation)
        case .rectangle:
            return unrotatedLeftMidPoint.rotate(around: center, by: rotation)
        case .triangle:
            return unrotatedLeftMidPoint.offsetBy(x: width / 4, y: 0)
                .rotate(around: center, by: rotation)
        }
    }

    var rightMidPoint: CGPoint {
        let unrotatedRightMidPoint = CGPoint(x: unrotatedFrame.maxX, y: unrotatedFrame.midY)
        switch shape {
        case .circle:
        return unrotatedRightMidPoint.rotate(around: center, by: rotation)
        case .rectangle:
            return unrotatedRightMidPoint.rotate(around: center, by: rotation)
        case .triangle:
            return unrotatedRightMidPoint.offsetBy(x: -width / 4, y: 0)
                .rotate(around: center, by: rotation)
        }
    }

    var unrotatedFrame: CGRect {
        rotate(by: -rotation).frame
    }

    var width: CGFloat {
        switch shape {
        case .circle:
            return .zero
        case .rectangle:
            return vertices[0].distanceTo(vertices[1])
        case .triangle:
            return vertices[0].distanceTo(vertices[1])
        }
    }

    var height: CGFloat {
        switch shape {
        case .circle:
            return .zero
        case .rectangle:
            return vertices[1].distanceTo(vertices[2])
        case .triangle:
            return width * sqrt(3) / 2
        }
    }

    /// Constructs a circle `PhysicsShape`.
    /// Returns a circle of radius 0 if the radius is negative.
    init(circleOfRadius: CGFloat, center: CGPoint, rotation: CGFloat = .zero) {

        self.shape = .circle
        self.center = center
        self.rotation = rotation
        self.vertices = []
        guard circleOfRadius >= 0 else {
            self.radius = .zero
            return
        }
        self.radius = circleOfRadius
    }

    /// Constructs a rectangle `PhysicsShape`.
    init(rectOfSize: CGSize, center: CGPoint, rotation: CGFloat = .zero) {

        self.shape = .rectangle
        self.center = center
        self.rotation = rotation
        self.radius = .zero
        let unrotatedVertices = PhysicsUtility.getVerticesOf(rectOfSize: rectOfSize, center: center)
        self.vertices = unrotatedVertices.map({ $0.rotate(around: center, by: rotation) })
    }
    /// Constructs a triangle `PhysicsShape`.
    init(triangleOfLength: CGFloat, center: CGPoint, rotation: CGFloat = .zero) {
        self.shape = .triangle
        self.center = center
        self.rotation = rotation
        self.radius = .zero
        let unrotatedVertices = PhysicsUtility
            .getVerticesOf(triangleOfLength: triangleOfLength, center: center)
        self.vertices = unrotatedVertices.map({ $0.rotate(around: center, by: rotation) })
    }

    /// Resizes this `PhysicsShape`. if the scale is negative, the shape is unchanged.
    func resize(by scale: CGFloat) -> PhysicsShape {
        guard scale >= 0 else {
            return self
        }
        switch shape {
        case .circle:
            return PhysicsShape(circleOfRadius: radius * scale, center: center, rotation: rotation)
        case .rectangle:
            return PhysicsShape(rectOfSize: CGSize(width: width * scale,
                                                   height: height * scale),
                                center: center, rotation: rotation)
        case .triangle:
            return PhysicsShape(triangleOfLength: width * scale, center: center, rotation: rotation)
        }
    }
    func overlaps(with physicsShape: PhysicsShape) -> Bool {
        switch shape {
        case .circle:
            switch physicsShape.shape {
            case .circle:
                return PhysicsUtility.hasOverlapBetween(circle1: self,
                                                        circle2: physicsShape)
            default:
                return PhysicsUtility.hasOverlapBetween(circle: self,
                                                        polygon: physicsShape)
            }
        default:
            switch physicsShape.shape {
            case .circle:
                return PhysicsUtility.hasOverlapBetween(circle: physicsShape,
                                                        polygon: self)
            default:
                return PhysicsUtility.hasOverlapBetween(polygon1: self,
                                                        polygon2: physicsShape)
            }
        }
    }

    func contains(_ point: CGPoint) -> Bool {
        switch shape {
        case .circle:
            return PhysicsUtility.contains(point, circle: self)
        case .rectangle:
            return PhysicsUtility.contains(point, rect: self)
        case .triangle:
            return PhysicsUtility.contains(point, triangle: self)
        }
    }

    func moveTo(_ position: CGPoint) -> PhysicsShape {
        switch shape {
        case .circle:
            return PhysicsShape(circleOfRadius: radius, center: position, rotation: rotation)
        case .rectangle:
            return PhysicsShape(rectOfSize: CGSize(width: width, height: height),
                                center: position, rotation: rotation)
        case .triangle:
            return PhysicsShape(triangleOfLength: width, center: position, rotation: rotation)
        }
    }
    func rotate(by angle: CGFloat) -> PhysicsShape {
        switch shape {
        case .circle:
            return PhysicsShape(circleOfRadius: radius,
                                center: center, rotation: rotation + angle)
        case .rectangle:
            return PhysicsShape(rectOfSize: CGSize(width: width, height: height),
                                center: center, rotation: rotation + angle)
        case .triangle:
            return PhysicsShape(triangleOfLength: width, center: center, rotation: rotation + angle)
        }
    }

}

// MARK: Hashable
extension PhysicsShape: Hashable {
}

// MARK: Codable
extension PhysicsShape: Codable {
}
