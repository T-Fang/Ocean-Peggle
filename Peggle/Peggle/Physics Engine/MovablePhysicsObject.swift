//
//  MovablePhysicsObject.swift
//  Peggle
//
//  Created by TFang on 9/2/21.
//

import CoreGraphics

/// `PhysicsObject` class represents a movable 2D object.
class MovablePhysicsObject: PhysicsObject, Movable {
    var velocity = CGVector.zero
    var acceleration = CGVector.zero

    override init(physicsShape: PhysicsShape) {
        super.init(physicsShape: physicsShape)
    }

    init(velocity: CGVector, acceleration: CGVector, physicsShape: PhysicsShape) {
        self.velocity = velocity
        self.acceleration = acceleration
        super.init(physicsShape: physicsShape)
    }

    /// Updates the velocity using the given speed and angle
    /// - Parameters:
    ///   - speed: the scalar magnitude of the velocity
    ///   - angle: the angle (in radian) between the velocity direction
    ///            and the positive y axis, with clockwise direction
    ///
    /// If the speed is negative, the velocity will be the zero vector
    func updateVelocity(speed: CGFloat, angle: CGFloat) {
        guard speed >= 0 else {
            velocity = .zero
            return
        }
        velocity = CGVector(dx: -speed * sin(angle), dy: speed * cos(angle))
    }

    /// Moves the object
    func move() {
        let newPosition = center.offsetBy(x: velocity.dx, y: velocity.dy)
        physicsShape = physicsShape.moveTo(newPosition)
        velocity = velocity.add(acceleration)
    }

    /// Checks whether this object will collide with the given object
    func willCollide(with object: PhysicsObject) -> Bool {
        let movedObject = makeCopy()
        movedObject.move()
        return movedObject.overlaps(with: object)
    }
    private func makeCopy() -> MovablePhysicsObject {
        MovablePhysicsObject(velocity: velocity, acceleration: acceleration, physicsShape: physicsShape)
    }

    /// Reflects the velocity along x axis (i.e. negates the x compoenent of current velocity)
    func reflectVelocityAlongXAxis() {
        velocity = velocity.reflectAlong(axis: CGVector(dx: 1, dy: 0))
    }

    /// Updates this object's attributes after colliding with the given object
    /// - Parameters:
    ///   - object: the object to cllide with
    ///   - cor: coefficient of restitution, which represents how much energy is lost after collision,
    ///          1 for perfectly elastic collision, and 0 for perfectly inelastic collision
    ///
    /// The given object must not overlap with this `MovablePhysicsObject`,
    /// otherwise this `MovablePhysicsObject` remains unchanged
    func collide(with object: PhysicsObject, cor: CGFloat = Constants.defaultCor) {
        guard !overlaps(with: object) else {
            return
        }
        switch object.physicsShape.shape {
        case .circle:
            collide(withCircle: object, cor: cor)
        }
    }

    private func collide(withCircle object: PhysicsObject, cor: CGFloat) {
        let axis = CGVector(dx: object.center.x - center.x,
                            dy: object.center.y - center.y)
        let reflectedVelocity = velocity.reflectAlong(axis: axis)
        velocity = CGVector(dx: reflectedVelocity.dx * cor,
                            dy: reflectedVelocity.dy * cor)

    }

}
