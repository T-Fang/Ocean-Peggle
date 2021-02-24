//
//  BucketView.swift
//  Peggle
//
//  Created by TFang on 20/2/21.
//

import UIKit

class BucketView: UIImageView {

    init(boardFrame: CGRect) {
        let size = CGSize(width: Constants.bucketWidth, height: Constants.bucketHeight)
        let origin = CGPoint(x: boardFrame.midX - Constants.bucketWidth / 2,
                             y: boardFrame.maxY - Constants.bucketHeight)
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
