//
//  CGVector+cosTheta.swift
//  Peggle
//
//  Created by TFang on 20/2/21.
//

import CoreGraphics

extension CGVector {
    static func generateVector(from point1: CGPoint, to point2: CGPoint) -> CGVector {
        CGVector(dx: point2.x - point1.x, dy: point2.y - point1.y)
    }

    func dotProduct(with other: CGVector) -> CGFloat {
        dx * other.dx + dy * other.dy
    }

    func cosTheta(with other: CGVector) -> CGFloat {
        dotProduct(with: other) / (norm * other.norm)
    }
}
