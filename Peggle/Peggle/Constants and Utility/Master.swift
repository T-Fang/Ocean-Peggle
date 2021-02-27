//
//  Master.swift
//  Peggle
//
//  Created by TFang on 12/2/21.
//

import UIKit

enum Master: String {
    case Splork
    case Renfield
    case Mike

    var name: String {
        switch self {
        case .Splork:
            return "Splork"
        case .Renfield:
            return "Renfield"
        case .Mike:
            return "Mike"
        }
    }
    var power: String {
        switch self {
        case .Splork:
            return "Power: Space Blast"
        case .Renfield:
            return "Power: Spooky Ball"
        case .Mike:
            return "Power: Blow Bubbles"
        }
    }
    var description: String {
        switch self {
        case .Splork:
            return "Uses super advanced alien technology to light up all nearby pegs!"
        case .Renfield:
            return "Makes the ball spookily reappear at the top after its exit from the bottom."
        case .Mike:
            return "Generates some bubbles that will lift the ball up!"
        }
    }

    var image: UIImage {
        switch self {
        case .Splork:
            return #imageLiteral(resourceName: "octopus")
        case .Renfield:
            return #imageLiteral(resourceName: "pumpkin")
        case .Mike:
            return #imageLiteral(resourceName: "fish")
        }
    }

    static let allMasters = [Master.Splork, .Renfield, .Mike]
}
