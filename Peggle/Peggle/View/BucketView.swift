//
//  BucketView.swift
//  Peggle
//
//  Created by TFang on 20/2/21.
//

import UIKit

class BucketView: UIImageView {

    init(boardFrame: CGRect) {
        let size = CGSize(width: Constants.defaultBucketWidth, height: Constants.defaultBucketHeight)
        let origin = CGPoint(x: boardFrame.midX - Constants.defaultBucketWidth / 2,
                             y: boardFrame.maxY - Constants.defaultBucketHeight)
        super.init(frame: CGRect(origin: origin, size: size))
        open()
    }

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }

    func moveTo(_ position: CGPoint) {
        self.center = position
    }

    func open() {
        image = #imageLiteral(resourceName: "bucket")
    }

    func close() {
        image = #imageLiteral(resourceName: "bucket_closed")
    }
}
