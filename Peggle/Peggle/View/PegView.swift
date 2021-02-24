//
//  PegView.swift
//  Peggle
//
//  Created by TFang on 27/1/21.
//

import UIKit

class PegView: UIView, OscillatableView, SelectableView, FadableView {

    private(set) var pegBody = UIImageView(image: #imageLiteral(resourceName: "peg-blue"))
    var handleView: UIView?
    var periodLabel: UIView?

    var isChosen = false

    private(set) var shape = PegShape.circle
    private(set) var color = PegColor.blue

    init(shape: PegShape, color: PegColor, unrotatedframe: CGRect, rotation: CGFloat = .zero) {
        self.shape = shape
        self.color = color
        super.init(frame: unrotatedframe)

        self.pegBody.frame = bounds
        addSubview(pegBody)
        refreshView()

        transform = transform.rotated(by: rotation)
    }

    func refreshView() {
        guard isChosen else {
            pegBody.image = DisplayUtility.getPegDimImage(color: color, shape: shape)
            unselectHandlePeriodViews()
            return
        }
        pegBody.image = DisplayUtility.getPegGlowImage(color: color, shape: shape)
        selectHandlePeriodViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}
