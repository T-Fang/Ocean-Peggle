//
//  Constants.swift
//  Peggle
//
//  Created by TFang on 27/1/21.
//

import UIKit

class Constants {

    // Alert title
    static let okTitle = "OK"
    static let errorTitle = "Error"
    static let cancelTitle = "Cancel"

    // Alert message
    static let noOrangePegMessage = "There must be at least one orange peg on the game board"
    static let saveLevelMessage = "Please enter an alphanumeric level name:"
    static let levelNameExists = "The input Level name already exists!"
    static let invalidLevelName = "Level name should be alphanumeric and should not be blank!"
    static let failedToSaveLevel = "Failed to save level!"
    static let deleteLevelMessage = "Are you sure you want to permanently delete this level?"

    // Message shown in a Peggle game
    static let extraBallMessage = "+1 Ball!"
    static let spookyBallActivatedMessage = "Spooky Ball Activated!"
    static let spaceBlastActivatedMessage = "Space Blast Activated!"

    static let masterChooserTableCellHeight: CGFloat = 145

    static let alphaForSelectedPaletteButton: CGFloat = 1
    static let alphaForUnselectedPaletteButton: CGFloat = 0.3
    static let alphaForSelectedHandle: CGFloat = 1
    static let alphaForUnselectedHandle: CGFloat = 0.4

    static let screenWidth = UIScreen.main.bounds.width
    static let defaultCannonHeight: CGFloat = 60
    static let defaultBucketHeight: CGFloat = 40
    static let defaultBucketWidth: CGFloat = 200

    static let spaceBlastRadius: CGFloat = 100
    static let defaultCirclePegRadius: CGFloat = 20
    static let maxCirclePegRadius: CGFloat = 40
    static let minCirclePegRadius: CGFloat = 20
    static let maxBlockHeight: CGFloat = 100
    static let minBlockHeight: CGFloat = 30
    static let maxBlockWidth: CGFloat = 100
    static let minBlockWidth: CGFloat = 30
    static let maxPeriod: CGFloat = 9.9
    static let minPeriod: CGFloat = 1
    static let defaultBallRadius: CGFloat = 15

    static let defaultHandleRadius: CGFloat = 15
    static let handleTouchableRadius: CGFloat = 20
    static let defaultHandleLength: CGFloat = 20
    static let defaultHandleWidth: CGFloat = 6

    static let defaultBallCount = 10
    static let hitCountForStuckObject = 15

    static let initialAcceleration = CGVector(dx: 0, dy: 0.2)
    static let initialBallSpeed: CGFloat = 90
    static let defaultBucketSpeed = CGVector(dx: 3, dy: 0)

    // cor stands for coefficient of restitution
    static let defaultCor: CGFloat = 0.7

    // Animation duration
    static let fadeAnimationDuration = 1.0
    static let bubbleAnimationDuration = 1.5
    static let messageLabelAnimationDuration = 2.0
}
