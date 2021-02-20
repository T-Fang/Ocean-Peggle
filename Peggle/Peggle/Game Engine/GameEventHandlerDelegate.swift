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
    func ballDidExitFromBottom()

    func didHitPeg(gamePeg: GamePeg)

    func ballCountDidChange(ballCount: Int)

    func orangePegCountDidChange(orangePegCount: Int)

//    func bucketDidMove(bucket: Bucket)
}
