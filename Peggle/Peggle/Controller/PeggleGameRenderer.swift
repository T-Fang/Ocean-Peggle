//
//  PeggleGameRenderer.swift
//  Peggle
//
//  Created by TFang on 25/2/21.
//

import Foundation

class PeggleGameRenderer {
    let engine: GameEngine
    init(engine: GameEngine) {
        self.engine = engine
    }
    func render(on boardView: GameBoardView) {
        boardView.resetBoard()
        if let ballView = ballView {
            boardView.addBallView(ballView)
        }
        boardView.addBucketView(bucketView)
        boardView.addPegViews(pegViews)
        boardView.addBlockViews(blockViews)
    }
    var ballView: BallView? {
        guard let ball = engine.ball else {
            return nil
        }
        let ballView = BallView(center: ball.center)
        if engine.spookyCount > 0 {
            ballView.putInPlasticBag()
        }

        return ballView
    }
    var bucketView: BucketView {
        let bucketView = BucketView(boardFrame: engine.frame)
        bucketView.moveTo(engine.bucket.center)
        return bucketView
    }
    var pegViews: [PegView] {
        engine.pegs.map({ DisplayUtility.getPegView(for: $0) })
    }
    var blockViews: [BlockView] {
        engine.blocks.map({ DisplayUtility.getBlockView(for: $0) })
    }
}
