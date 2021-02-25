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
    private var blockViews = [BlockView]()

    func addPegView(_ pegView: PegView) {
        pegViews.append(pegView)
        addSubview(pegView)
    }
    func addPegViews(_ pegViews: [PegView]) {
        self.pegViews.append(contentsOf: pegViews)
        pegViews.forEach({ addSubview($0) })
    }
    func addBlockViews(_ blcokViews: [BlockView]) {
        self.blockViews.append(contentsOf: blcokViews)
        blcokViews.forEach({ addSubview($0) })
    }
    func addBlockView(_ blockView: BlockView) {
        blockViews.append(blockView)
        addSubview(blockView)
    }
    func addBallView(_ ballView: BallView) {
        self.ballView = ballView
        addSubview(ballView)
    }
    func addBucketView(_ bucketView: BucketView) {
        self.bucketView = bucketView
        addSubview(bucketView)
    }

    func moveBall(to position: CGPoint) {
        ballView?.moveTo(position)
    }

    func moveBucket(to position: CGPoint) {
        bucketView?.moveTo(position)
    }

    func openBucket() {
        bucketView?.open()
    }

    func closeBucket() {
        bucketView?.close()
    }

    func resetBoard() {
        removeBall()
        removeBucket()
        removePegViews()
        removeBlockViews()
    }

    func removeBall() {
        ballView?.removeFromSuperview()
        ballView = nil
    }
    func removeBucket() {
        bucketView?.removeFromSuperview()
        bucketView = nil
    }
    func removePegViews() {
        pegViews.forEach({ $0.removeFromSuperview() })
        pegViews = []
    }
    func removeBlockViews() {
        blockViews.forEach({ $0.removeFromSuperview() })
        blockViews = []
    }

    func removeObjectEffect(objectView: FadableView) {
        addSubview(objectView)
        objectView.fade()
    }

    func bubbleEffect(at center: CGPoint) {
        let bubbleView = DisplayUtility.getBubbleImageView(at: center)
        addSubview(bubbleView)

        UIView.animate(withDuration: Constants.bubbleAnimationDuration,
                       delay: 0,
                       options: UIView.AnimationOptions.curveEaseInOut,
                       animations: { bubbleView.alpha = 0 },
                       completion: { _ in bubbleView.removeFromSuperview() })
    }
}
