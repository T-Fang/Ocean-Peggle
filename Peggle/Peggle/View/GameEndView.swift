//
//  GameEndView.swift
//  Peggle
//
//  Created by TFang on 11/2/21.
//

import UIKit

class GameEndView: UIView {
    @IBOutlet private var endResultLabel: UILabel!

    func showYouWin() {
        endResultLabel.text = "YOU WIN"
        isHidden = false
    }
    func showGameOver() {
        endResultLabel.text = "GAME OVER"
        isHidden = false
    }

    func hide() {
        isHidden = true
    }
}
