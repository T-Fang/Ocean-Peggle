//
//  CGVector+rotate.swift
//  Peggle
//
//  Created by TFang on 22/2/21.
//

import CoreGraphics

extension CGVector {
    /// Rotates the vector counter-clockwise
    func rotate(by angle: CGFloat) -> CGVector {
        let rotatedEndPoint = CGPoint(x: dx, y: dy).rotate(around: .zero, by: angle)
        return CGVector.generateVector(from: .zero, to: rotatedEndPoint)
    }
}
