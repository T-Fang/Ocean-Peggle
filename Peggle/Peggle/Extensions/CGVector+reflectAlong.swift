//
//  CGVector+reflectAlong.swift
//  Peggle
//
//  Created by TFang on 11/2/21.
//

import CoreGraphics

extension CGVector {
    var norm: CGFloat {
        sqrt(self.dx * self.dx + self.dy * self.dy)
    }

    func normalized() -> CGVector {
        CGVector(dx: self.dx / norm, dy: self.dy / norm)
    }

    /// Reflects the vector along the given axis
    /// - Parameters:
    ///   - axis: the direction of the nomal vector of the reflection surface
    func reflectAlong(axis: CGVector) -> CGVector {
        guard self != CGVector.zero, axis != CGVector.zero else {
            return self
        }

        let normal = axis.normalized()
        let componentAlongAxis = (self.dx * normal.dx + self.dy * normal.dy)
        return CGVector(dx: self.dx - 2 * componentAlongAxis * normal.dx,
                        dy: self.dy - 2 * componentAlongAxis * normal.dy)
    }
}
