//
//  BlockView.swift
//  Peggle
//
//  Created by TFang on 23/2/21.
//

import UIKit

class BlockView: UIView, OscillatableView, SelectableView {

    private(set) var blockBody = UIImageView(image: #imageLiteral(resourceName: "block"))
    var handleView: UIView?
    var periodLabel: UIView?

    var isChosen = false

    init(unrotatedframe: CGRect, rotation: CGFloat = .zero) {
        super.init(frame: unrotatedframe)

        self.blockBody.frame = bounds
        addSubview(blockBody)
        refreshView()

        transform = transform.rotated(by: rotation)
    }

    func fade() {
        UIView.animate(withDuration: Constants.fadeAnimationDuration,
                       delay: 0,
                       options: UIView.AnimationOptions.curveEaseInOut,
                       animations: { self.alpha = 0 })
    }

    func refreshView() {
        guard isChosen else {
            blockBody.image = #imageLiteral(resourceName: "block")
            unselectHandlePeriodViews()
            return
        }
        blockBody.image = #imageLiteral(resourceName: "block-glow")
        selectHandlePeriodViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
