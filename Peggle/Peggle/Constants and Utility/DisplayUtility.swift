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
            }
        }
    }
}
