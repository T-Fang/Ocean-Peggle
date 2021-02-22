//
//  Handle.swift
//  Peggle
//
//  Created by TFang on 21/2/21.
//

import CoreGraphics

struct Handle {
    var startPosition: CGPoint
    var endPosition: CGPoint

    var touchArea: PhysicsShape {
        PhysicsShape(circleOfRadius: Constants.defaultHandleRadius, center: endPosition)
    }

}
