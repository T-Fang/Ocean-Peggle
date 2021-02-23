//
//  SelectableView.swift
//  Peggle
//
//  Created by TFang on 22/2/21.
//

import UIKit

protocol SelectableView: UIView {
    var isChosen: Bool { get set }

    func refreshView()
}

extension SelectableView {
    func select() {
        isChosen = true
        refreshView()
    }

    func unselect() {
        isChosen = false
        refreshView()
    }
}
