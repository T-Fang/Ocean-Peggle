//
//  CGPoint+distanceToLineBetween.swift
//  Peggle
//
//  Created by TFang on 20/2/21.
//

import CoreGraphics

extension CGPoint {
    /// - Returns: the orthogonal projection of a point on the line speficied by the given two point
    func projectedPointOnLineBetween(_ p1: CGPoint, _ p2: CGPoint) -> CGPoint {
        let p1ToP2 = CGVector.generateVector(from: p1, to: p2)
        let normalizedP1P2 = p1ToP2.normalized()
        let p1ToSelf = CGVector.generateVector(from: p1, to: self)
        let dotWithNormalizedLine = p1ToSelf.dotProduct(with: normalizedP1P2)
        return p1.offsetBy(x: dotWithNormalizedLine * normalizedP1P2.dx,
                           y: dotWithNormalizedLine * normalizedP1P2.dy)
    }

    func distanceToLineBetween(_ p1: CGPoint, _ p2: CGPoint) -> CGFloat {
        let projectedPoint = projectedPointOnLineBetween(p1, p2)
        return self.distanceTo(projectedPoint)
    }

    func isOnLineBetween(_ p1: CGPoint, _ p2: CGPoint) -> Bool {

        let selfToP1 = distanceTo(p1)
        let selfToP2 = distanceTo(p2)
        let p1ToP2 = p1.distanceTo(p2)

        let tolerableError = CGFloat(0.001)

        return selfToP1 + selfToP2 >= p1ToP2 - tolerableError
            && selfToP1 + selfToP2 <= p1ToP2 + tolerableError
    }
}
