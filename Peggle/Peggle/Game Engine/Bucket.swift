//
//  Bucket.swift
//  Peggle
//
//  Created by TFang on 20/2/21.
//

import CoreGraphics

class Bucket: MovablePhysicsObject {

    private var initialCenter: CGPoint
    private var isClosed = false

    init(gameFrame: CGRect) {
        let size = CGSize(width: Constants.defaultBucketWidth, height: Constants.defaultBucketHeight)
        let center = CGPoint(x: gameFrame.midX, y: gameFrame.maxY - Constants.defaultBucketHeight / 2)
        self.initialCenter = center
        super.init(velocity: Constants.defaultBucketSpeed,
                   acceleration: .zero,
                   physicsShape: PhysicsShape(rectOfSize: size, center: center))
    }

    func close() {
        isClosed = true
    }

    func open() {
        isClosed = false
    }

    func isEnteringBucket(ball: Ball) -> Bool {
        ball.center.x > center.x - Constants.defaultBucketWidth / 2 &&
            ball.center.x < center.x + Constants.defaultBucketWidth / 2
    }

    func reset() {
        center = initialCenter
        velocity = Constants.defaultBucketSpeed
        open()
    }
}
