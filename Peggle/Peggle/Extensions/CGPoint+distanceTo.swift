//
//  CGPoint+distanceTo.swift
//  Peggle
//
//  Created by TFang on 11/2/21.
//

import CoreGraphics

extension CGPoint {
    func distanceTo(_ point: CGPoint) -> CGFloat {
        let xDistance = (x - point.x)
        let yDistance = (y - point.y)
        return sqrt((xDistance * xDistance) + (yDistance * yDistance))
    }
}
