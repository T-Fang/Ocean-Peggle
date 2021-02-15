//
//  MasterChooserTableCell.swift
//  Peggle
//
//  Created by TFang on 12/2/21.
//

import UIKit

class MasterChooserTableCell: UITableViewCell {

    @IBOutlet private var masterName: UILabel!
    @IBOutlet private var masterPower: UILabel!
    @IBOutlet private var masterDescription: UILabel!
    @IBOutlet private var masterImage: UIImageView!

    func setUp(master: Master) {
        masterName.text = master.name
        masterPower.text = master.power
        masterDescription.text = master.description
        masterImage.image = master.image
    }

}
