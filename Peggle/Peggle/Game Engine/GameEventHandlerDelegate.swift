//
//  GameEventHandlerDelegate.swift
//  Peggle
//
//  Created by TFang on 10/2/21.
//

import CoreGraphics

/// `GameEventHandlerDelegate` contains methods a controller can implement
/// to respond to various events happened to the `GameEngine`
protocol GameEventHandlerDelegate: AnyObject {
    func willRemovePeg(gamePeg: GamePeg)
    func willRemoveBlock(gameBlock: GameBlock)

    func didRemoveBall()

    func didHitBucket()

    func ballCountDidChange(ballCount: Int)

    func orangePegCountDidChange(orangePegCount: Int)

    func objectsDidMove()

    func didActivateSpaceBlast(at point: CGPoint)

    func showMessage(_ message: String)
}
