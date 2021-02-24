//
//  Bucket.swift
//  Peggle
//
//  Created by TFang on 20/2/21.
//

import CoreGraphics

class Bucket: MovablePhysicsObject {

    private var initialCenter: CGPoint
    private var minX: CGFloat
    private var maxX: CGFloat
    private var isOpen = true

    init(gameFrame: CGRect) {
        let size = CGSize(width: Constants.bucketWidth, height: Constants.bucketHeight)
        let center = CGPoint(x: gameFrame.midX, y: gameFrame.maxY - Constants.bucketHeight / 2)
        self.initialCenter = center
        self.minX = gameFrame.minX
        self.maxX = gameFrame.maxX
        super.init(velocity: Constants.bucketSpeed,
                   acceleration: .zero,
                   physicsShape: PhysicsShape(rectOfSize: size, center: center))
    }

    override func move() {

        var newPosition = center.offset(by: velocity)
        if frame.minX < minX {
            newPosition = CGPoint(x: minX + frame.width / 2, y: frame.midY)
            reflectVelocityAlongXAxis()
        }
        if frame.maxX > maxX {
            newPosition = CGPoint(x: maxX - frame.width / 2, y: frame.midY)
            reflectVelocityAlongXAxis()
        }
        physicsShape = physicsShape.moveTo(newPosition)
    }

    func close() {
        isOpen = false
    }

    func open() {
        isOpen = true
    }

    func willEnterBucket(ball: Ball) -> Bool {
        guard isOpen, ball.willCollide(with: self) else {
            return false
        }
        let ballCopy = ball.makeCopy()
        ballCopy.moveToCollisionPosition(with: self)
        return ballCopy.center.x > center.x - Constants.bucketWidth / 2
            && ballCopy.center.x < center.x + Constants.bucketWidth / 2
    }

    func reset() {
        center = initialCenter
        velocity = Constants.bucketSpeed
        open()
    }
}
