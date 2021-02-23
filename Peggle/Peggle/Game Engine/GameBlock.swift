//
//  GameBlock.swift
//  Peggle
//
//  Created by TFang on 24/2/21.
//

import CoreGraphics

class GameBlock: OscillatableObject {

}

extension GameBlock: Hashable {
    static func == (lhs: GameBlock, rhs: GameBlock) -> Bool {
        lhs.physicsShape == rhs.physicsShape
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(physicsShape)
    }
}
