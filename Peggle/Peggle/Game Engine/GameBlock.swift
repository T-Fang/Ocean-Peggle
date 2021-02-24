//
//  GameBlock.swift
//  Peggle
//
//  Created by TFang on 24/2/21.
//

class GameBlock: OscillatableObject {
    let block: Block
    init(block: Block) {
        self.block = block
        super.init(physicsShape: block.physicsShape,
                   period: block.period, initialDirection: block.initialDirection,
                   amplitude: block.amplitude, movementCenter: block.movementCenter)
    }
}

extension GameBlock: Hashable {
    static func == (lhs: GameBlock, rhs: GameBlock) -> Bool {
        lhs.physicsShape == rhs.physicsShape
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(physicsShape)
    }
}
