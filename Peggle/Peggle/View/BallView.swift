//
//  BallView.swift
//  Peggle
//
//  Created by TFang on 11/2/21.
//

import UIKit

class BallView: UIImageView {

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }

    init(center: CGPoint,
         radius: CGFloat = Constants.defaultBallRadius) {
        let frame = CGRect(x: center.x - radius, y: center.y - radius, width: radius * 2, height: radius * 2)
        super.init(frame: frame)
        self.image = #imageLiteral(resourceName: "ball")
    }

    func moveTo(position: CGPoint) {
        self.center = position
    }

}
