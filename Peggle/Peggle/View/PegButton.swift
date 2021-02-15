//
//  PegButton.swift
//  Peggle
//
//  Created by TFang on 12/2/21.
//

import UIKit

class PegButton: UIButton {
    private(set) var color: PegColor? {
        didSet {
            refreshPegButtonImage()
        }
    }
    private(set) var shape: PegShape? {
        didSet {
            refreshPegButtonImage()
        }
    }

    func setUp(color: PegColor, shape: PegShape) {
        self.color = color
        self.shape = shape
    }

    func select() {
        alpha = Constants.alphaForSelectedPegButton
    }

    func unselect() {
        alpha = Constants.alphaForUnselectedPegButton
    }

    private func refreshPegButtonImage() {
        guard let color = color, let shape = shape else {
            return
        }
        setImage(DisplayUtility.getPegDimImage(color: color, shape: shape), for: .normal)
    }

}
