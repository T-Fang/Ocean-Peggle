//
//  PhysicsWorld.swift
//  Peggle
//
//  Created by TFang on 10/2/21.
//

import CoreGraphics

/// `PhysicsWorld` represents a 2D physics world that contains zero or more objects of type `Object`.
/// `Object` is a generic type, which should be a subclass of `PhysicsObject`
/// `PhysicsWorld`'s primary job is to detect collisions between objects and bounds of this 2D world.
///
/// Note that collisions between objects should be detected using methods inside `PhysicsObject`.
/// Additionally, a world itself is infinitely expandable,
/// hence object can be added anywhere. The `frame` is simply a rectangle saying which location is "valid"
class PhysicsWorld<Object: PhysicsObject> {

    private var frame: CGRect
    private(set) var objects: [Object] = []

    init(frame: CGRect) {
        self.frame = frame
    }

    func updateFrame(frame: CGRect) {
        self.frame = frame
    }

    func add(_ object: Object) {
        objects.append(object)
    }

    func remove(_ object: Object) {
        objects.removeAll(where: { $0 === object })
    }

    func remove(_ objectsToBeRemoved: [Object]) {
        objectsToBeRemoved.forEach { object in
            objects.removeAll(where: { $0 === object })
        }
    }

    func reset() {
        objects.removeAll()
    }

    func hasCollidedWithTop(object: PhysicsObject) -> Bool {
        object.frame.minY <= frame.minY
    }

    func hasCollidedWithBottom(object: PhysicsObject) -> Bool {
        object.frame.maxY >= frame.maxY
    }

    func hasCollidedWithLeftSide(object: PhysicsObject) -> Bool {
        object.frame.minX <= frame.minX
    }

    func hasCollidedWithRightSide(object: PhysicsObject) -> Bool {
        object.frame.maxX >= frame.maxX
    }

    func hasCollidedWithSide(object: PhysicsObject) -> Bool {
        hasCollidedWithLeftSide(object: object) || hasCollidedWithRightSide(object: object)
    }

}