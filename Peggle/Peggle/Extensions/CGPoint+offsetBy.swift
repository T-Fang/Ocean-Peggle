//
//  CGPoint+offsetBy.swift
//  Peggle
//
//  Created by TFang on 12/2/21.
//

import CoreGraphics

extension CGPoint {
    func offsetBy(x: CGFloat, y: CGFloat) -> CGPoint {
        let newX = self.x + x
        let newY = self.y + y
        return CGPoint(x: newX, y: newY)
    }
}
