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

    var name: String {
        switch self {
        case .Splork:
            return "Splork"
        case .Renfield:
            return "Renfield"
        }
    }
    var power: String {
        switch self {
        case .Splork:
            return "Power: Space Blast"
        case .Renfield:
            return "Power: Spooky Ball"
        }
    }
    var description: String {
        switch self {
        case .Splork:
            return "Uses super advanced alien technology to light up all nearby pegs!"
        case .Renfield:
            return "Makes the ball spookily reappear at the top after its exit from the bottom."
        }
    }

    var image: UIImage {
        switch self {
        case .Splork:
            return #imageLiteral(resourceName: "octopus")
        case .Renfield:
            return #imageLiteral(resourceName: "pumpkin")
        }
    }

    static let allMasters = [Master.Splork, .Renfield]
}
