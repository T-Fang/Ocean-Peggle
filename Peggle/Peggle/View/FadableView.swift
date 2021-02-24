//
//  FadableView.swift
//  Peggle
//
//  Created by TFang on 25/2/21.
//

import UIKit

protocol FadableView: UIView {
}

extension FadableView {
    func fade() {
        UIView.animate(withDuration: Constants.fadeAnimationDuration,
                       delay: 0,
                       options: UIView.AnimationOptions.curveEaseInOut,
                       animations: { self.alpha = 0 },
                       completion: {_ in self.removeFromSuperview() })
    }
}
