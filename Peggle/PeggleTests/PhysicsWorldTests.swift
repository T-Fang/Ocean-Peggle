//
//  PhysicsWorldTests.swift
//  PeggleTests
//
//  Created by TFang on 13/2/21.
//

import XCTest
@testable import Peggle

class PhysicsWorldTests: XCTestCase {
    let emptyFrame = CGRect.zero
    let frame1 = CGRect(x: 0, y: 0, width: 120, height: 120)
    let frame2 = CGRect(x: -150, y: -250, width: 300, height: 500)
    let object1 = PhysicsObject(physicsShape: PhysicsShape(circleOfRadius: 20, center: CGPoint(x: 100, y: 100)))
    let sameObject1 = PhysicsObject(physicsShape: PhysicsShape(circleOfRadius: 20, center: CGPoint(x: 100, y: 100)))
    let object2 = PhysicsObject(physicsShape: PhysicsShape(circleOfRadius: 10, center: CGPoint(x: 200, y: 150)))
    let object3 = PhysicsObject(physicsShape: PhysicsShape(circleOfRadius: 20, center: CGPoint(x: 110, y: 110)))
    let object4 = PhysicsObject(physicsShape: PhysicsShape(circleOfRadius: 5, center: CGPoint(x: 0, y: 0)))
    let object5 = PhysicsObject(physicsShape: PhysicsShape(circleOfRadius: 5, center: CGPoint(x: 5, y: 5)))
    let movableObject1 = MovablePhysicsObject(
        physicsShape: PhysicsShape(circleOfRadius: 20, center: CGPoint(x: 100, y: 100)))

    func testConstruct() {
        let world1 = PhysicsWorld<PhysicsObject>(frame: emptyFrame)
        XCTAssertTrue(world1.objects.isEmpty)
        let world2 = PhysicsWorld<MovablePhysicsObject>(frame: frame1)
        XCTAssertTrue(world2.objects.isEmpty)
    }

    func testAdd() {
        let world = PhysicsWorld<PhysicsObject>(frame: frame1)
        world.add(object1)
        XCTAssertEqual(world.objects.count, 1)
        world.add(sameObject1)
        XCTAssertEqual(world.objects.count, 2)
        world.add(movableObject1)
        XCTAssertEqual(world.objects.count, 3)
        world.add(object2)
        XCTAssertEqual(world.objects.count, 4)
    }

    func testRemove() {
        let world = PhysicsWorld<PhysicsObject>(frame: frame2)
        world.remove(object1)
        XCTAssertEqual(world.objects.count, 0)
        world.add(object1)
        world.add(sameObject1)
        world.remove(sameObject1)
        XCTAssertTrue(world.objects.first === object1)
        XCTAssertFalse(world.objects.first === sameObject1)
        world.add(movableObject1)
        world.remove(movableObject1)
        XCTAssertEqual(world.objects.count, 1)
        world.add(movableObject1)
        world.remove([object1, movableObject1])
        XCTAssertEqual(world.objects.count, 0)
    }

    func testReset() {
        let world = PhysicsWorld<MovablePhysicsObject>(frame: frame1)
        XCTAssertTrue(world.objects.isEmpty)
        world.add(movableObject1)
        world.reset()
        XCTAssertTrue(world.objects.isEmpty)
    }

    func testHasCollidedWithTop() {
        let world1 = PhysicsWorld<PhysicsObject>(frame: frame1)
        let world2 = PhysicsWorld<PhysicsObject>(frame: frame2)
        world1.add(object4)
        world1.add(object5)
        world2.add(object4)
        world1.add(object5)
        XCTAssertTrue(world1.hasCollidedWithTop(object: object4))
        XCTAssertTrue(world1.hasCollidedWithTop(object: object5))
        XCTAssertFalse(world2.hasCollidedWithTop(object: object4))
        XCTAssertFalse(world2.hasCollidedWithTop(object: object5))
    }

    func testHasCollidedWithLeftSide() {
        let world1 = PhysicsWorld<PhysicsObject>(frame: frame1)
        let world2 = PhysicsWorld<PhysicsObject>(frame: frame2)
        world1.add(object4)
        world1.add(object5)
        world2.add(object4)
        world1.add(object5)
        XCTAssertTrue(world1.hasCollidedWithLeftSide(object: object4))
        XCTAssertTrue(world1.hasCollidedWithLeftSide(object: object5))
        XCTAssertFalse(world2.hasCollidedWithLeftSide(object: object4))
        XCTAssertFalse(world2.hasCollidedWithLeftSide(object: object5))
    }

    func testHasCollidedWithRightSide() {
        let world1 = PhysicsWorld<PhysicsObject>(frame: frame1)
        let world2 = PhysicsWorld<PhysicsObject>(frame: frame2)
        world1.add(object1)
        world1.add(object3)
        world2.add(object1)
        world1.add(object3)
        XCTAssertTrue(world1.hasCollidedWithRightSide(object: object1))
        XCTAssertTrue(world1.hasCollidedWithRightSide(object: object3))
        XCTAssertFalse(world2.hasCollidedWithRightSide(object: object1))
        XCTAssertFalse(world2.hasCollidedWithRightSide(object: object3))
    }

    func testHasCollidedWithBottom() {
        let world1 = PhysicsWorld<PhysicsObject>(frame: frame1)
        let world2 = PhysicsWorld<PhysicsObject>(frame: frame2)
        world1.add(object1)
        world1.add(object3)
        world2.add(object1)
        world1.add(object3)
        XCTAssertTrue(world1.hasCollidedWithBottom(object: object1))
        XCTAssertTrue(world1.hasCollidedWithBottom(object: object3))
        XCTAssertFalse(world2.hasCollidedWithBottom(object: object1))
        XCTAssertFalse(world2.hasCollidedWithBottom(object: object3))
    }

    // Note that there is no need to test `hasCollidedWithSide`
    // considering left and right collision detection are already tested
}
