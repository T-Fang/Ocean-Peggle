//
//  BucketView.swift
//  Peggle
//
//  Created by TFang on 20/2/21.
//

import UIKit

class BucketView: UIImageView {

    func moveTo(point: CGPoint) {
        self.center = point
    }

    func open() {
        image = #imageLiteral(resourceName: "bucket")
    }

    func close() {
        image = #imageLiteral(resourceName: "bucket_closed")
    }
}
