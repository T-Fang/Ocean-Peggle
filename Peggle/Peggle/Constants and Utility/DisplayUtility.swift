//
//  DisplayUtility.swift
//  Peggle
//
//  Created by TFang on 12/2/21.
//

import UIKit
class DisplayUtility {
    static func getPegDimImage(color: PegColor, shape: PegShape) -> UIImage {
        switch shape {
        case .circle:
            switch color {
            case .blue:
                return #imageLiteral(resourceName: "peg-blue")
            case .orange:
                return #imageLiteral(resourceName: "peg-orange")
            case .green:
                return #imageLiteral(resourceName: "peg-green")
            }
        }
    }

    static func getPegGlowImage(color: PegColor, shape: PegShape) -> UIImage {
        switch shape {
        case .circle:
            switch color {
            case .blue:
                return #imageLiteral(resourceName: "peg-blue-glow")
            case .orange:
                return #imageLiteral(resourceName: "peg-orange-glow")
            case .green:
                return #imageLiteral(resourceName: "peg-green-glow")
            }
        }
    }

    static func getBubbleImageView(at center: CGPoint) -> UIImageView {
        let radius = Constants.spaceBlastRadius
        let frame = CGRect(x: center.x - radius,
                           y: center.y - radius,
                           width: radius * 2,
                           height: radius * 2)

        let bubble = UIImageView(frame: frame)
        bubble.image = #imageLiteral(resourceName: "soap-bubbles")
        bubble.layer.cornerRadius = radius
        bubble.clipsToBounds = true
        return bubble
    }
}
