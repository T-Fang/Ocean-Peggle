//
//  CGPoint+Hashable.swift
//  Peggle
//
//  Created by TFang on 11/2/21.
//

import CoreGraphics

extension CGPoint: Hashable {
    static func == (lhs: CGPoint, rhs: CGPoint) -> Bool {
        lhs.x == rhs.x && lhs.y == rhs.y
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}
