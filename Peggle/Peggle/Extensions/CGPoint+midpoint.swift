//
//  CGPoint+midpoint.swift
//  Peggle
//
//  Created by TFang on 22/2/21.
//

import CoreGraphics

extension CGPoint {
    func midpoint(with other: CGPoint) -> CGPoint {
        CGPoint(x: (x + other.x) / 2, y: (y + other.y) / 2)
    }
}
