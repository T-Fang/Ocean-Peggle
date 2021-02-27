//
//  Constants.swift
//  Peggle
//
//  Created by TFang on 27/1/21.
//

import UIKit

class Constants {
    // MARK: Alert title
    static let okTitle = "OK"
    static let errorTitle = "Error"
    static let cancelTitle = "Cancel"

    // MARK: Alert message
    static let noOrangePegMessage = "There must be at least one orange peg on the game board"
    static let saveLevelMessage = "Please enter an alphanumeric level name:"
    static let levelNameExists = "The input Level name already exists!"
    static let invalidLevelName = "Level name should be alphanumeric and should not be blank!"
    static let failedToSaveLevel = "Failed to save level!"
    static let deleteLevelMessage = "Are you sure you want to permanently delete this level?"
    static let sameNameAsPreloadedLevelMessage =
        "Level name cannot be the same as one the names of the preloaded levels!"
    static let cannotDeletePreloadedLevelMessage = "Preloaded levels cannot be deleted!"

    // MARK: Message shown in a Peggle game
    static let extraBallMessage = "+1 Ball!"
    static let spookyBallActivatedMessage = "Spooky Ball Activated!"
    static let spaceBlastActivatedMessage = "Space Blast Activated!"
    static let blowBubbleActivatedMessage = "Blow Bubble Activated!"

    // MARK: Preloaded Level
    static let preloadedLevelNames = ["Preloaded-DNA", "Preloaded-ChainReaction", "Preloaded-Tree"]

    // MARK: Alpha Constants
    static let alphaForSelectedPaletteButton: CGFloat = 1
    static let alphaForUnselectedPaletteButton: CGFloat = 0.3
    static let alphaForSelectedHandle: CGFloat = 1
    static let alphaForUnselectedHandle: CGFloat = 0.4
    static let alphaForEnabledPeriodSlider: CGFloat = 1
    static let alphaForDisabledPeriodSlider: CGFloat = 0.4

    // MARK: UIView Constants
    static let masterChooserTableCellHeight: CGFloat = 145
    static let screenWidth = UIScreen.main.bounds.width

    // MARK: Cannon, Ball, Bucket Constants
    static let cannonHeight: CGFloat = 60
    static let ballRadius: CGFloat = 15
    static let bucketHeight: CGFloat = 40
    static let bucketWidth: CGFloat = 200

    // MARK: Peg Constants
    static let defaultCirclePegRadius: CGFloat = 20
    static let maxCirclePegRadius: CGFloat = 40
    static let minCirclePegRadius: CGFloat = 18
    static let defaultTriangleSideLength: CGFloat = 50
    static let maxTriangleSideLength: CGFloat = 80
    static let minTriangleSideLength: CGFloat = 40

    // MARK: Block Constants
    static let maxBlockHeight: CGFloat = 150
    static let minBlockHeight: CGFloat = 40
    static let maxBlockWidth: CGFloat = 150
    static let minBlockWidth: CGFloat = 40

    // MARK: Oscillation Constants
    static let handleRadius: CGFloat = 15
    static let handleTouchableRadius: CGFloat = 20
    static let defaultHandleLength: CGFloat = 20
    static let handleWidth: CGFloat = 6
    static let maxPeriod: CGFloat = 9.9
    static let minPeriod: CGFloat = 1

    // MARK: Power Up Constants
    static let spaceBlastRadius: CGFloat = 100
    static let floatingBubblesRadius: CGFloat = 60
    static let alphaForfloatingBubbles: CGFloat = 0.6

    // MARK: Game Engine Constants
    static let defaultBallCount = 10
    static let hitCountForStuckObject = 15
    static let gravitationalAcceleration = CGVector(dx: 0, dy: 0.2)
    static let floatingAcceleration = CGVector(dx: 0, dy: -0.2)
    static let initialBallSpeed: CGFloat = 20
    static let bucketSpeed = CGVector(dx: 3, dy: 0)
    static let floatingBubbleReduceRate = 0.7

    // MARK: Physics Engine Constants
    // cor stands for coefficient of restitution
    static let defaultCor: CGFloat = 0.7
    static let wallThickness: CGFloat = 0.1

    // MARK: Animation duration
    static let fadeAnimationDuration = 1.0
    static let bubbleAnimationDuration = 1.5
    static let messageLabelAnimationDuration = 2.0

    // MARK: Tolerable Error
    static let errorForMovement: CGFloat = 0.001
    static let maxNumberOfMovementAdjustment = 500
    static let errorForCollisionDetection: CGFloat = 0.000_001

    // MARK: Peg Score
    static let otherPegsScore = 10
    static let orangePegScore = 100

}
