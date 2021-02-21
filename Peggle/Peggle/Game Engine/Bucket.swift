//
//  Bucket.swift
//  Peggle
//
//  Created by TFang on 20/2/21.
//

import CoreGraphics

class Bucket: MovablePhysicsObject {

    private var initialCenter: CGPoint
    private var isOpen = true

    init(gameFrame: CGRect) {
        let size = CGSize(width: Constants.defaultBucketWidth, height: Constants.defaultBucketHeight)
        let center = CGPoint(x: gameFrame.midX, y: gameFrame.maxY - Constants.defaultBucketHeight / 2)
        self.initialCenter = center
        super.init(velocity: Constants.defaultBucketSpeed,
                   acceleration: .zero,
                   physicsShape: PhysicsShape(rectOfSize: size, center: center))
    }

    func close() {
        isOpen = false
    }

    func open() {
        isOpen = true
    }

    func willEnterBucket(ball: Ball) -> Bool {
        guard isOpen else {
            return false
        }
        let movedBall = ball.movedCopy
        return movedBall.center.x > center.x - Constants.defaultBucketWidth / 2
            && movedBall.center.x < center.x + Constants.defaultBucketWidth / 2
    }

    func reset() {
        center = initialCenter
        velocity = Constants.defaultBucketSpeed
        open()
    }
}
