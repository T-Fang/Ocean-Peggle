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

    var movedCopy: MovablePhysicsObject {
        let movedObject = makeCopy()
        movedObject.move()
        return movedObject
    }

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
        let newPosition = center.offset(by: velocity)
        physicsShape = physicsShape.moveTo(newPosition)
        velocity = velocity.add(acceleration)
    }

    func move(distance: CGFloat) {
        guard distance >= 0 else {
            return
        }
        let newPosition = center.offset(by: velocity.normalized.scale(by: distance))
        physicsShape = physicsShape.moveTo(newPosition)
        let time = distance / velocity.norm
        velocity = velocity.add(acceleration.scale(by: time))
    }
    /// Checks whether this object will collide with the given object.
    /// Returns false if this object overlaps with the given object.
    func willCollide(with object: PhysicsObject) -> Bool {
        guard let distance = moveDistance(to: object), !overlaps(with: object) else {
            return false
        }
        return distance >= 0 && distance <= velocity.norm
    }

    func nearestCollidingObject(among objects: [PhysicsObject]) -> PhysicsObject? {
        let collidingObjects = objects.filter({ willCollide(with: $0) })

        var nearestObject: PhysicsObject?
        var minMoveDistance: CGFloat?
        for object in collidingObjects {
            guard let distance = moveDistance(to: object) else {
                continue
            }
            guard let currentMin = minMoveDistance else {
                nearestObject = object
                minMoveDistance = distance
                continue
            }
            if distance < currentMin {
                nearestObject = object
                minMoveDistance = distance
            }
        }
        return nearestObject
    }
    func makeCopy() -> MovablePhysicsObject {
        MovablePhysicsObject(velocity: velocity, acceleration: acceleration, physicsShape: physicsShape)
    }

    /// Reflects the velocity along x axis (i.e. negates the x compoenent of current velocity)
    func reflectVelocityAlongXAxis() {
        velocity = velocity.reflectAlong(axis: CGVector(dx: 1, dy: 0))
    }

    /// Reflects the velocity along y axis (i.e. negates the y compoenent of current velocity)
    func reflectVelocityAlongYAxis() {
        velocity = velocity.reflectAlong(axis: CGVector(dx: 0, dy: 1))
    }

    /// Updates this object's attributes after colliding with the given object
    /// - Parameters:
    ///   - object: the object to cllide with
    ///   - cor: coefficient of restitution, which represents how much energy is lost after collision,
    ///          1 for perfectly elastic collision, and 0 for perfectly inelastic collision
    ///
    /// Currently, this object has to be a circle.
    /// The given object must not overlap with this `MovablePhysicsObject`,
    /// otherwise this `MovablePhysicsObject` remains unchanged
    func collide(with object: PhysicsObject, cor: CGFloat = Constants.defaultCor) {
        guard willCollide(with: object) else {
            return
        }

        switch object.physicsShape.shape {
        case .circle:
            collide(withCircle: object, cor: cor)
        default:
            collide(withPolygon: object, cor: cor)
        }

        var count = 0
        while overlaps(with: object) || willCollide(with: object),
              count <= Constants.maxNumberOfMovementAdjustment {
            count += 1
            move(distance: Constants.errorForMovement)
        }

        count = 0
        while overlaps(with: object) || willCollide(with: object),
              count <= Constants.maxNumberOfMovementAdjustment {
            count += 1
            move()
        }
    }

    func collide(withPolygon object: PhysicsObject, cor: CGFloat) {
        let info = getInfoOfCollision(withPolygon: object)
        guard let distance = info.moveDistance else {
            return
        }
        move(distance: distance)

        guard let collidingSide = info.collidingSide else {
            guard let collidingPoint = info.collidingPoint else {
                return
            }

            let axis = CGVector.generateVector(from: object.center, to: collidingPoint)
            let reflectedVelocity = velocity.reflectAlong(axis: axis)
            velocity = reflectedVelocity.scale(by: cor)
            return
        }
        let projectedPoint = center.projectedPointOnLineBetween(collidingSide.0, collidingSide.1)
        let axis = CGVector.generateVector(from: projectedPoint, to: center)
        let reflectedVelocity = velocity.reflectAlong(axis: axis)
        velocity = reflectedVelocity.scale(by: cor)
    }

    private func collide(withCircle object: PhysicsObject, cor: CGFloat) {
        guard let distance = moveDistance(to: object) else {
            return
        }
        move(distance: distance)
        let axis = CGVector(dx: object.center.x - center.x,
                            dy: object.center.y - center.y)
        let reflectedVelocity = velocity.reflectAlong(axis: axis)
        velocity = CGVector(dx: reflectedVelocity.dx * cor,
                            dy: reflectedVelocity.dy * cor)

    }
    func moveDistance(to object: PhysicsObject) -> CGFloat? {
        guard physicsShape.shape == .circle && !overlaps(with: object) else {
            return nil
        }

        switch object.physicsShape.shape {
        case .circle:
            return moveDistance(toCircle: object)
        default:
            return getInfoOfCollision(withPolygon: object).moveDistance
        }
    }
    private func moveDistance(toCircle: PhysicsObject) -> CGFloat? {
        guard physicsShape.shape == .circle && toCircle.physicsShape.shape == .circle
                && !overlaps(with: toCircle) else {
            return nil
        }
        // Law of Cosines
        let vectorConnectingTwoCenters = CGVector.generateVector(from: center, to: toCircle.center)
        let sumOfRadius = toCircle.physicsShape.radius + physicsShape.radius
        let cosTheta = vectorConnectingTwoCenters.cosTheta(with: velocity)

        // a = 1 for this Quadratic Equation
        let b = -2 * vectorConnectingTwoCenters.norm * cosTheta
        let c = (vectorConnectingTwoCenters.norm + sumOfRadius)
            * (vectorConnectingTwoCenters.norm - sumOfRadius)

        return findNonNegtiveLeastRoot(a: 1, b: b, c: c)
    }
    private func getInfoOfCollision(withPolygon: PhysicsObject) -> CollisionInfo {
        var info = CollisionInfo()
        guard physicsShape.shape == .circle && withPolygon.physicsShape.shape != .circle
                && !overlaps(with: withPolygon) else {
            return info
        }

        let vertices = withPolygon.physicsShape.vertices
        for i in vertices.indices {
            let point1 = vertices[i]
            let point2 = vertices[(i + 1) % vertices.count]

            info.update(with: getInfoOfCollisionWithLineBetween(point1, point2))
        }
        return info
    }
    private func getInfoOfCollisionWith(_ P: CGPoint) -> CollisionInfo {
        var info = CollisionInfo()
        guard !physicsShape.contains(P) else {
            return info
        }

        let centerToP = CGVector.generateVector(from: center, to: P)
        let a = velocity.dotProduct(with: velocity)
        let b = -2 * (centerToP.dotProduct(with: velocity))
        let c = centerToP.dotProduct(with: centerToP) - physicsShape.radius * physicsShape.radius

        guard let time = findNonNegtiveLeastRoot(a: a, b: b, c: c) else {
            return info
        }

        info.updateCollidingPoint(point: P)
        info.updateMinMoveDistance(time * velocity.norm)
        return info
    }
    private func getInfoOfCollisionWithLineBetween(_ p1: CGPoint, _ p2: CGPoint) -> CollisionInfo {
        var info = CollisionInfo()
        guard physicsShape.shape == .circle && !PhysicsUtility
                .intersectsWithLineBetween(p1, p2, circle: self.physicsShape) else {
            return info
        }

        info.update(with: getInfoOfCollisionWith(p1))
        info.update(with: getInfoOfCollisionWith(p2))

        let projectedPointP = center.projectedPointOnLineBetween(p1, p2)
        let centerToP = CGVector.generateVector(from: center, to: projectedPointP)
        let componentOnCenterToP = velocity.componentOn(centerToP)

        guard componentOnCenterToP > 0 && centerToP.norm >= physicsShape.radius else {
            return info
        }

        let distance = velocity.norm
            * (centerToP.norm - physicsShape.radius) / componentOnCenterToP
        let shapeAtCollidingPosition = physicsShape
            .moveTo(center.offset(by: velocity.normalized.scale(by: distance)))
        guard PhysicsUtility
                .intersectsWithLineBetween(p1, p2, circle: shapeAtCollidingPosition) else {
            return info
        }

        info.update(distance: distance, side: (p1, p2))
        return info
    }
    private func findNonNegtiveLeastRoot(a: CGFloat, b: CGFloat, c: CGFloat) -> CGFloat? {
        let delta = b * b - 4 * a * c
        guard delta >= 0 else {
            return nil
        }

        let leastRoot = (-b - sqrt(delta)) / (2 * a)
        guard leastRoot >= 0 else {
            return nil
        }
        return leastRoot
    }
}
