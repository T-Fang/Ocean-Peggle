//
//  CGVector+add.swift
//  Peggle
//
//  Created by TFang on 13/2/21.
//

import CoreGraphics

extension CGVector {
    func add(_ vector: CGVector) -> CGVector {
        CGVector(dx: dx + vector.dx, dy: dy + vector.dy)
    }
}
