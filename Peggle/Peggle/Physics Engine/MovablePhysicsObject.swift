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
        guard willCollide(with: object) && !overlaps(with: object) else {
            return
        }
        moveToCollisionPosition(with: object)
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

    private func moveToCollisionPosition(with object: PhysicsObject) {
        guard willCollide(with: object) && !overlaps(with: object) else {
            return
        }

        switch object.physicsShape.shape {
        case .circle:
            // use Law of Cosines to calculate the distance required to move
            // the object to the collision position, where it borders the other object
            let vectorConnectingTwoCenters = CGVector(dx: object.center.x - center.x,
                                                      dy: object.center.y - center.y)
            let sumOfRadius = object.physicsShape.radius + physicsShape.radius
            let cosTheta = vectorConnectingTwoCenters.cosTheta(with: velocity)

            let b = -2 * vectorConnectingTwoCenters.norm * cosTheta
            let c = (vectorConnectingTwoCenters.norm + sumOfRadius)
                * (vectorConnectingTwoCenters.norm - sumOfRadius)
            // it is guarranted to have this root because the two object will collide
            let moveDistance = (-b - sqrt(b * b - 4 * c)) / 2
            assert(moveDistance > 0)

            let collisionPosition = center.offsetBy(x: moveDistance * velocity.normalized().dx,
                                                    y: moveDistance * velocity.normalized().dy)
            physicsShape = physicsShape.moveTo(collisionPosition)
            velocity = velocity.add(acceleration)

        }
    }
}
