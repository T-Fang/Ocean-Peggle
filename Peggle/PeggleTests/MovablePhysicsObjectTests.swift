//
//  MovablePhysicsObjectTests.swift
//  PeggleTests
//
//  Created by TFang on 13/2/21.
//

import XCTest
@testable import Peggle

class MovablePhysicsObjectTests: XCTestCase {
    // Note that `reflectVelocityAlongXAxis()` is tested in VectorTests
    // since it is just calling `reflectAlong`
    let center1 = CGPoint(x: 100, y: 100)
    let center2 = CGPoint(x: 200, y: 300)
    let shape1 = PhysicsShape(circleOfRadius: 20, center: CGPoint(x: 100, y: 100))
    let shape2 = PhysicsShape(circleOfRadius: 30, center: CGPoint(x: 200, y: 300))
    let shape3 = PhysicsShape(circleOfRadius: 10, center: CGPoint(x: 131, y: 101))
    let shape4 = PhysicsShape(circleOfRadius: 5, center: CGPoint(x: 130, y: 100))

    let velocity1 = CGVector(dx: 1, dy: 1)
    let acceleration1 = CGVector(dx: 0.4, dy: 0.5)
    let pi = CGFloat(Double.pi)

    let tolerableRotateError: CGFloat = 0.000_000_000_001
    private func withinTolerableError(expected: CGVector, actual: CGVector) -> Bool {
        let isXOk = expected.dx - tolerableRotateError <= actual.dx
            && expected.dx + tolerableRotateError >= actual.dx
        let isYOk = expected.dy - tolerableRotateError <= actual.dy
            && expected.dy + tolerableRotateError >= actual.dy
        return isXOk && isYOk
    }

    func testConstruct() {
        let object1 = MovablePhysicsObject(physicsShape: shape1)
        XCTAssertEqual(object1.acceleration, .zero)
        XCTAssertEqual(object1.velocity, .zero)
        XCTAssertEqual(object1.center, center1)
        let object2 = MovablePhysicsObject(velocity: velocity1, acceleration: acceleration1, physicsShape: shape2)
        XCTAssertEqual(object2.acceleration, acceleration1)
        XCTAssertEqual(object2.velocity, velocity1)
        XCTAssertEqual(object2.center, center2)
    }

    func testUpdateVelocity_negativeSpeed_zeroVelocity() {
        let object = MovablePhysicsObject(physicsShape: shape2)
        object.updateVelocity(speed: 0, angle: pi / 2)
        XCTAssertEqual(object.velocity, .zero)
    }
    func testUpdateVelocity() {
        let object = MovablePhysicsObject(physicsShape: shape2)
        object.updateVelocity(speed: 3, angle: 1.5 * pi)
        XCTAssertTrue(withinTolerableError(expected: CGVector(dx: 3, dy: 0),
                                           actual: object.velocity))
        object.updateVelocity(speed: 10, angle: pi)
        XCTAssertTrue(withinTolerableError(expected: CGVector(dx: 0, dy: -10),
                                           actual: object.velocity))
        object.updateVelocity(speed: 5, angle: 0)
        XCTAssertTrue(withinTolerableError(expected: CGVector(dx: 0, dy: 5),
                                           actual: object.velocity))
        object.updateVelocity(speed: 10, angle: pi / 6)
        XCTAssertTrue(withinTolerableError(expected: CGVector(dx: -5, dy: 5 * sqrt(3)),
                                           actual: object.velocity))
        object.updateVelocity(speed: 2, angle: -pi / 4)
        XCTAssertTrue(withinTolerableError(expected: CGVector(dx: sqrt(2), dy: sqrt(2)),
                                           actual: object.velocity))
    }

    func testMove() {
        let object1 = MovablePhysicsObject(velocity: velocity1, acceleration: acceleration1, physicsShape: shape1)
        object1.move()
        XCTAssertEqual(object1.acceleration, acceleration1)
        XCTAssertEqual(object1.velocity, CGVector(dx: 1.4, dy: 1.5))
        XCTAssertEqual(object1.center, CGPoint(x: 101, y: 101))
        let object2 = MovablePhysicsObject(physicsShape: shape2)
        object2.move()
        XCTAssertEqual(object2.acceleration, .zero)
        XCTAssertEqual(object2.velocity, .zero)
        XCTAssertEqual(object2.center, center2)
    }

    func testWillCollide_willNotCollide_false() {
        let object1 = MovablePhysicsObject(velocity: velocity1, acceleration: acceleration1, physicsShape: shape1)
        let object2 = MovablePhysicsObject(physicsShape: shape2)
        XCTAssertFalse(object1.willCollide(with: object2))
    }
    func testWillCollide_overlaps_false() {
        let object1 = MovablePhysicsObject(velocity: velocity1, acceleration: acceleration1, physicsShape: shape2)
        XCTAssertFalse(object1.willCollide(with: object1))
    }

    func testCollide_collideWithOverlappingObject_remainUnchanged() {
        let originalObject = MovablePhysicsObject(velocity: velocity1,
                                                  acceleration: acceleration1, physicsShape: shape3)
        let object1 = MovablePhysicsObject(velocity: velocity1, acceleration: acceleration1, physicsShape: shape3)
        let object2 = MovablePhysicsObject(velocity: velocity1, acceleration: acceleration1, physicsShape: shape3)
        object2.move()

        object1.collide(with: object1)
        XCTAssertEqual(originalObject.velocity, object1.velocity)
        XCTAssertEqual(originalObject.acceleration, object1.acceleration)
        XCTAssertEqual(originalObject.center, object1.center)

        object1.collide(with: object2)
        XCTAssertEqual(originalObject.velocity, object1.velocity)
        XCTAssertEqual(originalObject.acceleration, object1.acceleration)
        XCTAssertEqual(originalObject.center, object1.center)
    }
}
