//
//  CannonView.swift
//  Peggle
//
//  Created by TFang on 11/2/21.
//

import UIKit

class CannonView: UIImageView {

    private(set) var angle: CGFloat = 0

    func rotate(to angle: CGFloat) {
        self.angle = angle
        transform = CGAffineTransform(rotationAngle: angle)
    }

    func resetCannon() {
        self.angle = 0
        transform = CGAffineTransform(rotationAngle: 0)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        image = #imageLiteral(resourceName: "cannon")
    }

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
}
