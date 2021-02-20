//
//  GameBoardView.swift
//  Peggle
//
//  Created by TFang on 30/1/21.
//

import UIKit

class GameBoardView: UIView {

    private var bucketView: BucketView?
    private var ballView: BallView?
    private var pegViews = [PegView]()

    func addPegView(_ pegView: PegView) {
        pegViews.append(pegView)
        addSubview(pegView)
    }
    func removePegFromBoard(_ pegView: PegView) {
        pegViews.removeAll(where: { $0 === pegView })
        pegView.removeFromSuperview()
    }

    func launchBall(at position: CGPoint) {
        let ballView = BallView(center: position)
        addSubview(ballView)
        self.ballView = ballView
    }

    func moveBall(to position: CGPoint) {
        ballView?.moveTo(position: position)
    }

    func removeBall() {
        ballView?.removeFromSuperview()
        ballView = nil
    }

    func resetBoard() {
        bucketView?.center.x = center.x
        removeBall()
        pegViews.forEach({ removePegFromBoard($0) })
    }
}
