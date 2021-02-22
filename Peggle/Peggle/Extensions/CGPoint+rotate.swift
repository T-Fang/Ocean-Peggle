//
//  CGPoint+rotate.swift
//  Peggle
//
//  Created by TFang on 13/2/21.
//

import CoreGraphics

extension CGPoint {
    /// Rotates the point counter-clockwise
    func rotate(around point: CGPoint, by angle: CGFloat) -> CGPoint {
        guard angle != CGFloat.zero else {
            return self
        }

        let dx = x - point.x
        let dy = y - point.y
        let distance = sqrt(dx * dx + dy * dy)
        let oldAngle = atan2(dy, dx)
        let newAngle = oldAngle + angle
        let newX = point.x + distance * cos(newAngle)
        let newY = point.y + distance * sin(newAngle)
        return CGPoint(x: newX, y: newY)
    }
}
