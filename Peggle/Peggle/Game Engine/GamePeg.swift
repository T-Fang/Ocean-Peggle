//
//  GamePeg.swift
//  Peggle
//
//  Created by TFang on 10/2/21.
//

import CoreGraphics

class GamePeg: PhysicsObject {

    let peg: Peg
    private(set) var hitCount = 0

    var shape: PegShape {
        peg.shape
    }

    var color: PegColor {
        peg.color
    }

    init(peg: Peg) {
        self.peg = peg
        super.init(physicsShape: peg.physicsShape)
    }

    func increaseHitCount() {
        hitCount += 1
    }
}

extension GamePeg: Hashable {
    static func == (lhs: GamePeg, rhs: GamePeg) -> Bool {
        lhs.physicsShape == rhs.physicsShape
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(physicsShape)
    }
}