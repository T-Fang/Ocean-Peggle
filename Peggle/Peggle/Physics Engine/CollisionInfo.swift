//
//  CollisionInfo.swift
//  Peggle
//
//  Created by TFang on 25/2/21.
//

import CoreGraphics

struct CollisionInfo {
    var moveDistance: CGFloat?
    var collidingSide: (CGPoint, CGPoint)?
    var collidingPoint: CGPoint?

    mutating func update(with info: CollisionInfo) {
        guard updateMinMoveDistance(info.moveDistance) else {
            return
        }
        self.collidingSide = info.collidingSide
        self.collidingPoint = info.collidingPoint
    }

    mutating func update(distance: CGFloat?, side: (CGPoint, CGPoint)) {
        guard updateMinMoveDistance(distance) else {
            return
        }
        updateCollidingSide(side: side)
    }

    @discardableResult
    mutating func updateMinMoveDistance(_ distance: CGFloat?) -> Bool {
        guard let distance = distance, distance >= 0 else {
            return false
        }

        guard let currentMin = moveDistance else {
            moveDistance = distance
            return true
        }

        if distance < currentMin {
            moveDistance = distance
            return true
        } else {
            return false
        }
    }

    mutating func updateCollidingSide(side: (CGPoint, CGPoint)) {
        self.collidingSide = side
        self.collidingPoint = nil
    }

    mutating func updateCollidingPoint(point: CGPoint) {
        self.collidingSide = nil
        self.collidingPoint = point
    }
}
