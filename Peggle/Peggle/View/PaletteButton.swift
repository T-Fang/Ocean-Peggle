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
            refreshView()
        }
    }
    private(set) var shape: PegShape? {
        didSet {
            refreshView()
        }
    }
    private(set) var type = TypeOfButton.peg

    var isChosen = false

    func setUp(type: TypeOfButton) {
        self.type = type
    }

    func setUpPegButton(color: PegColor, shape: PegShape) {
        self.color = color
        self.shape = shape
        self.type = .peg
    }

    func refreshView() {
        guard let color = color, let shape = shape else {
            return
        }
        setImage(DisplayUtility.getPegDimImage(color: color, shape: shape), for: .normal)

        guard isChosen else {
            alpha = Constants.alphaForUnselectedPaletteButton
            return
        }
        alpha = Constants.alphaForSelectedPaletteButton
    }
}

enum TypeOfButton {
    case peg
    case erase
    case block
}
