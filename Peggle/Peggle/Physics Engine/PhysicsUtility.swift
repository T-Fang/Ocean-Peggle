//
//  PhysicsUtility.swift
//  Peggle
//
//  Created by TFang on 23/2/21.
//

import CoreGraphics

class PhysicsUtility {

    static func getVerticesOf(rectOfSize: CGSize, center: CGPoint) -> [CGPoint] {
        let height = rectOfSize.height
        let width = rectOfSize.width

        let topLeft = center.offsetBy(x: -width / 2, y: -height / 2)
        let topRight = center.offsetBy(x: width / 2, y: -height / 2)
        let bottomLeft = center.offsetBy(x: -width / 2, y: height / 2)
        let bottomRight = center.offsetBy(x: width / 2, y: height / 2)
        return [topLeft, topRight, bottomRight, bottomLeft]
    }

    static func contains(_ P: CGPoint, circle: PhysicsShape) -> Bool {
        guard circle.shape == .circle else {
            return false
        }

        return circle.center.distanceTo(P) <= circle.radius
    }

    static func contains(_ P: CGPoint, rect: PhysicsShape) -> Bool {
        guard rect.shape == .rectangle else {
            return false
        }

        let A = rect.vertices[0] // top left vertex
        let B = rect.vertices[1] // top right vertex
        let C = rect.vertices[2] // bottom right vertex

        let AB = CGVector.generateVector(from: A, to: B)
        let BC = CGVector.generateVector(from: B, to: C)
        let AP = CGVector.generateVector(from: A, to: P)
        let BP = CGVector.generateVector(from: B, to: P)

        return 0 <= AB.dotProduct(with: AP)
            && AB.dotProduct(with: AP) <= AB.dotProduct(with: AB)
            && 0 <= BC.dotProduct(with: BP)
            && BC.dotProduct(with: BP) <= BC.dotProduct(with: BC)
    }

    static func hasOverlapBetween(circle1: PhysicsShape, circle2: PhysicsShape) -> Bool {
        guard circle1.shape == .circle && circle2.shape == .circle else {
            return false
        }

        return circle1.center.distanceTo(circle2.center) <= circle1.radius + circle2.radius
    }

    static func hasOverlapBetween(circle: PhysicsShape, polygon: PhysicsShape) -> Bool {
        guard circle.shape == .circle && polygon.shape != .circle else {
            return false
        }

        let vertices = polygon.vertices
        for i in vertices.indices {
            let point1 = vertices[i]
            let point2 = vertices[(i + 1) % vertices.count]
            if PhysicsUtility.intersectsWithLineBetween(point1, point2, circle: circle) {
                return true
            }
        }

        return polygon.contains(circle.center)
    }

    static func hasOverlapBetween(polygon1: PhysicsShape, polygon2: PhysicsShape) -> Bool {
        guard polygon1.shape != .circle && polygon2.shape != .circle else {
            return false
        }

        let vertices1 = polygon1.vertices
        let vertices2 = polygon2.vertices

        for i in vertices1.indices {
            let start1 = vertices1[i]
            let end1 = vertices1[(i + 1) % vertices1.count]
            for j in vertices2.indices {
                let start2 = vertices2[j]
                let end2 = vertices2[(j + 1) % vertices2.count]
                if PhysicsUtility.intersectsBetweenLines(start1: start1, end1: end1,
                                                         start2: start2, end2: end2) != nil {
                    return true
                }
            }
        }

        return polygon2.contains(vertices1[0]) || polygon1.contains(vertices2[0])
    }

    static func intersectsWithLineBetween(_ p1: CGPoint, _ p2: CGPoint,
                                          circle: PhysicsShape) -> Bool {
        guard circle.shape == .circle else {
            return false
        }
        if circle.contains(p1) || circle.contains(p2) {
            return true
        }

        let projectedPoint = circle.center.projectedPointOnLineBetween(p1, p2)
        guard projectedPoint.isOnLineBetween(p1, p2) else {
            return false
        }

        let tolerableError = CGFloat(0.000_000_001)
        return circle.center.distanceToLineBetween(p1, p2) <= circle.radius + tolerableError
    }

    // Adapted from:
    // https://www.hackingwithswift.com/example-code/core-graphics/how-to-calculate-the-point-where-two-lines-intersect
    static func intersectsBetweenLines(start1: CGPoint, end1: CGPoint, start2: CGPoint,
                                       end2: CGPoint) -> (x: CGFloat, y: CGFloat)? {
        // calculate the differences between the start and end X/Y positions for each of our points
        let delta1x = end1.x - start1.x
        let delta1y = end1.y - start1.y
        let delta2x = end2.x - start2.x
        let delta2y = end2.y - start2.y

        // create a 2D matrix from our vectors and calculate the determinant
        let determinant = delta1x * delta2y - delta2x * delta1y

        if abs(determinant) < 0.000_1 {
            // if the determinant is effectively zero then the lines are parallel/colinear
            return nil
        }

        // if the coefficients both lie between 0 and 1 then we have an intersection
        let ab = ((start1.y - start2.y) * delta2x - (start1.x - start2.x) * delta2y) / determinant

        if ab > 0 && ab < 1 {
            let cd = ((start1.y - start2.y) * delta1x - (start1.x - start2.x) * delta1y) / determinant

            if cd > 0 && cd < 1 {
                // lines cross – figure out exactly where and return it
                let intersectX = start1.x + ab * delta1x
                let intersectY = start1.y + ab * delta1y
                return (intersectX, intersectY)
            }
        }

        // lines don't cross
        return nil
    }
}
