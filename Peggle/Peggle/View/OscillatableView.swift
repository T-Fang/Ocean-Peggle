//
//  OscillatableView.swift
//  Peggle
//
//  Created by TFang on 23/2/21.
//

import UIKit

protocol OscillatableView: UIView {
    var handleView: UIView? { get set }
    var periodLabel: UIView? { get set }
}

extension OscillatableView {
    func setUp(handleView: UIView, periodLabel: UIView) {
        self.handleView = handleView
        self.periodLabel = periodLabel
        addSubview(handleView)
        addSubview(periodLabel)
        bringSubviewToFront(periodLabel)
        sendSubviewToBack(handleView)

        unselectHandlePeriodViews()
    }

    func selectHandlePeriodViews() {
        handleView?.alpha = Constants.alphaForSelectedHandle
        periodLabel?.isHidden = false
    }

    func unselectHandlePeriodViews() {
        handleView?.alpha = Constants.alphaForUnselectedHandle
        periodLabel?.isHidden = true
    }
}
