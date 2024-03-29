//
//  HomeController.swift
//  Peggle
//
//  Created by TFang on 29/1/21.
//

import UIKit

class HomeController: UIViewController {
    override var prefersStatusBarHidden: Bool {
        true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        StorageUtility.preloadLevels()
        AudioPlayer.playBackgroundMusic()
    }

    @IBAction private func backToHomeMenu(_ segue: UIStoryboardSegue) {
        AudioPlayer.stop()
        AudioPlayer.playBackgroundMusic()
    }
}
