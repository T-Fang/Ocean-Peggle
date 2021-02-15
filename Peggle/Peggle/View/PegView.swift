//
//  PegView.swift
//  Peggle
//
//  Created by TFang on 27/1/21.
//

import UIKit

class PegView: UIImageView {
    var isGlowing = false {
        didSet {
            refreshPegImage()
        }
    }

    private(set) var shape = PegShape.circle
    private(set) var color = PegColor.blue

    init(shape: PegShape, color: PegColor, frame: CGRect) {
        self.shape = shape
        self.color = color
        super.init(frame: frame)
        refreshPegImage()
    }

    func fade() {
        UIView.animate(withDuration: 1,
                       delay: 0,
                       options: UIView.AnimationOptions.curveEaseInOut,
                       animations: { self.alpha = 0 })
    }

    func glow() {
        isGlowing = true
    }

    func dim() {
        isGlowing = false
    }

    private func refreshPegImage() {
        image = isGlowing ? DisplayUtility.getPegGlowImage(color: color, shape: shape)
            : DisplayUtility.getPegDimImage(color: color, shape: shape)
    }

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }

}