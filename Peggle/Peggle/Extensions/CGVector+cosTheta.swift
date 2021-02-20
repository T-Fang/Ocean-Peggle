//
//  CGVector+cosTheta.swift
//  Peggle
//
//  Created by TFang on 20/2/21.
//

import CoreGraphics

extension CGVector {
    func dotProduct(with other: CGVector) -> CGFloat {
        dx * other.dx + dy * other.dy
    }

    func cosTheta(with other: CGVector) -> CGFloat {
        dotProduct(with: other) / (norm * other.norm)
    }
}
