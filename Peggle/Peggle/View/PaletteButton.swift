//
//  PaletteButton.swift
//  Peggle
//
//  Created by TFang on 12/2/21.
//

import UIKit

class PaletteButton: UIButton, SelectableView {
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
    private(set) var type = TypeOfButton.peg

    func setUp(type: TypeOfButton) {
        self.type = type
    }

    func setUpPegButton(color: PegColor, shape: PegShape) {
        self.color = color
        self.shape = shape
        self.type = .peg
    }

    func select() {
        alpha = Constants.alphaForSelectedPaletteButton
    }

    func unselect() {
        alpha = Constants.alphaForUnselectedPaletteButton
    }

    private func refreshPegButtonImage() {
        guard let color = color, let shape = shape else {
            return
        }
        setImage(DisplayUtility.getPegDimImage(color: color, shape: shape), for: .normal)
    }

}

enum TypeOfButton {
    case peg
    case erase
    case block
}
