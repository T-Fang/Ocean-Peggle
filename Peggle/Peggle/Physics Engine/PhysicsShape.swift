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
            guard let minX = sortedX.last,
                  let maxX = sortedX.first,
                  let minY = sortedY.last,
                  let maxY = sortedY.first else {
                return .zero
            }

            let width = maxX - minX
            let height = maxY - minY
            let origin = CGPoint(x: minX, y: minY)
            return CGRect(origin: origin, size: CGSize(width: width, height: height))
        }
    }

    var leftMidPoint: CGPoint {
        let unrotatedLeftMidPoint = CGPoint(x: bounds.minX, y: bounds.midY)
        switch shape {
        case .circle:
        return unrotatedLeftMidPoint.rotate(around: center, by: rotation)
        case .rectangle:
            return unrotatedLeftMidPoint.rotate(around: center, by: rotation)
            // TODO add triangle's
        }
    }

    var rightMidPoint: CGPoint {
        let unrotatedRightMidPoint = CGPoint(x: bounds.maxX, y: bounds.midY)
        switch shape {
        case .circle:
        return unrotatedRightMidPoint.rotate(around: center, by: rotation)
        case .rectangle:
            return unrotatedRightMidPoint.rotate(around: center, by: rotation)
            // TODO add triangle's
        }
    }

    var bounds: CGRect {
        rotate(by: -rotation).frame
    }

    var width: CGFloat {
        switch shape {
        case .circle:
            return .zero
        case .rectangle:
            return vertices[0].distanceTo(vertices[1])
        }
    }

    var height: CGFloat {
        switch shape {
        case .circle:
            return .zero
        case .rectangle:
            return vertices[1].distanceTo(vertices[2])
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
        let unrotatedVertices = PhysicsShape.getVerticesOf(rectOfSize: rectOfSize, center: center)
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
        }
    }
    func overlaps(with physicsShape: PhysicsShape) -> Bool {
        switch shape {
        case .circle:
            switch physicsShape.shape {
            case .circle:
                return center.distanceTo(physicsShape.center) <= radius + physicsShape.radius
            default:
                return circleOverlapsWith(polygon: physicsShape)
            }
        default:
            return false
        }
    }

    func contains(_ point: CGPoint) -> Bool {
        switch shape {
        case .circle:
            return center.distanceTo(point) <= radius
        case .rectangle:
            return rectangeContains(point)
        }
    }

    func moveTo(_ position: CGPoint) -> PhysicsShape {
        switch shape {
        case .circle:
            return PhysicsShape(circleOfRadius: radius, center: position, rotation: rotation)
        case .rectangle:
            return PhysicsShape(rectOfSize: CGSize(width: width, height: height),
                                center: position, rotation: rotation)
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

        }
    }

    private static func getVerticesOf(rectOfSize: CGSize, center: CGPoint) -> [CGPoint] {
        let height = rectOfSize.height
        let width = rectOfSize.width

        let topLeft = center.offsetBy(x: -width / 2, y: -height / 2)
        let topRight = center.offsetBy(x: width / 2, y: -height / 2)
        let bottomLeft = center.offsetBy(x: -width / 2, y: height / 2)
        let bottomRight = center.offsetBy(x: width / 2, y: height / 2)
        return [topLeft, topRight, bottomRight, bottomLeft]
    }

    private func circleOverlapsWith(polygon: PhysicsShape) -> Bool {
        guard shape == .circle && polygon.shape != .circle else {
            return false
        }
        if polygon.contains(center) {
            return true
        }

        let vertices = polygon.vertices
        for i in vertices.indices {
            let point1 = vertices[i]
            let point2 = vertices[(i + 1) % vertices.count]
            if circleIntersectWithLineBetween(point1, point2) {
                return true
            }
        }

        return false
    }

    func circleIntersectWithLineBetween(_ p1: CGPoint, _ p2: CGPoint) -> Bool {
        guard shape == .circle else {
            return false
        }
        if contains(p1) || contains(p2) {
            return true
        }

        let projectedPoint = center.projectedPointOnLineBetween(p1, p2)
        guard projectedPoint.isOnLineBetween(p1, p2) else {
            return false
        }

        let tolerableError = CGFloat(0.001)
        return center.distanceToLineBetween(p1, p2) <= radius + tolerableError
    }

    private func rectangeContains(_ P: CGPoint) -> Bool {
        guard shape == .rectangle else {
            return false
        }

        let A = vertices[0] // top left vertex
        let B = vertices[1] // top right vertex
        let C = vertices[2] // bottom right vertex

        let AB = CGVector.generateVector(from: A, to: B)
        let BC = CGVector.generateVector(from: B, to: C)
        let AP = CGVector.generateVector(from: A, to: P)
        let BP = CGVector.generateVector(from: B, to: P)

        return 0 <= AB.dotProduct(with: AP)
            && AB.dotProduct(with: AP) <= AB.dotProduct(with: AB)
            && 0 <= BC.dotProduct(with: BP)
            && BC.dotProduct(with: BP) <= BC.dotProduct(with: BC)
    }
}

// MARK: Hashable
extension PhysicsShape: Hashable {
}

// MARK: Codable
extension PhysicsShape: Codable {
}
