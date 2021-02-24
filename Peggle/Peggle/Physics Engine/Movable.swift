//
//  Movable.swift
//  Peggle
//
//  Created by TFang on 9/2/21.
//

import CoreGraphics

protocol Movable {
    func move()
    func undoMove()
    func willCollide(with object: PhysicsObject) -> Bool
    func collide(with object: PhysicsObject, cor: CGFloat)
    func nearestCollidingObject(among objects: [PhysicsObject]) -> PhysicsObject?
    func moveDistance(to object: PhysicsObject) -> CGFloat?
}
