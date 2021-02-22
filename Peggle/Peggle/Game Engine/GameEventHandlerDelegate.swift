//
//  GameEventHandlerDelegate.swift
//  Peggle
//
//  Created by TFang on 10/2/21.
//

/// `GameEventHandlerDelegate` contains methods a controller can implement
/// to respond to various events happened to the `GameEngine`
protocol GameEventHandlerDelegate: AnyObject {
    func willRemovePegs(gamePegs: [GamePeg])

    func ballDidMove(ball: Ball)
    func didRemoveBall()

    func didHitPeg(gamePeg: GamePeg)
    func didHitBucket()

    func ballCountDidChange(ballCount: Int)

    func orangePegCountDidChange(orangePegCount: Int)

    func bucketDidMove(bucket: Bucket)

    func spookyCountDidChange(spookyCount: Int)
    func didActivateSpaceBlast(gamePeg: GamePeg)
    func didActivateSpookyBall()

    func showMessage(_ message: String)
}
