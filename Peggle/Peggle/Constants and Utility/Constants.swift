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

    static let masterChooserTableCellHeight: CGFloat = 145

    static let alphaForSelectedPegButton: CGFloat = 1
    static let alphaForUnselectedPegButton: CGFloat = 0.3

    static let screenWidth = UIScreen.main.bounds.width
    static let defaultCannonHeight: CGFloat = 60
    static let defaultBucketHeight: CGFloat = 40
    static let defaultBucketWidth: CGFloat = 200

    static let defaultCirclePegRadius: CGFloat = 20
    static let maxCirclePegRadius: CGFloat = 40
    static let minCirclePegRadius: CGFloat = 15
    static let defaultBallRadius: CGFloat = 15
    static let defaultBallCount = 10
    static let hitCountForStuckPeg = 15
    static let initialAcceleration = CGVector(dx: 0, dy: 0.2)
    static let initialBallSpeed: CGFloat = 8

    // cor stands for coefficient of restitution
    static let defaultCor: CGFloat = 0.7
}
