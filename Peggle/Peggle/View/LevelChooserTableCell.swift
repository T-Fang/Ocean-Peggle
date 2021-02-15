//
//  LevelChooserTableCell.swift
//  Peggle
//
//  Created by TFang on 28/1/21.
//

import UIKit

class LevelChooserTableCell: UITableViewCell {

    @IBOutlet private var levelNameLabel: UILabel!

    var levelName: String = "" {
        didSet {
            levelNameLabel.text = levelName
        }
    }
}
