//
//  CGVector+reflectAlong.swift
//  Peggle
//
//  Created by TFang on 11/2/21.
//

import CoreGraphics

extension CGVector {

    var normalized: CGVector {
        guard norm > 0 else {
            return self
        }
        return CGVector(dx: self.dx / norm, dy: self.dy / norm)
    }

    func componentOn(_ vector: CGVector) -> CGFloat {
        dotProduct(with: vector.normalized)
    }

    func scale(by scale: CGFloat) -> CGVector {
        CGVector(dx: self.dx * scale, dy: self.dy * scale)
    }

    func projectionOn(_ vector: CGVector) -> CGVector {
        vector.normalized.scale(by: componentOn(vector))
    }

    /// Reflects the vector along the given axis
    /// - Parameters:
    ///   - axis: the direction of the nomal vector of the reflection surface
    func reflectAlong(axis: CGVector) -> CGVector {
        guard self != CGVector.zero, axis != CGVector.zero else {
            return self
        }

        return add(projectionOn(axis).scale(by: -2))
    }
}
