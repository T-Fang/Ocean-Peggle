//
//  LevelChooserController.swift
//  Peggle
//
//  Created by TFang on 28/1/21.
//

import UIKit

class LevelChooserController: UIViewController {
    var currentSelectedLevel: PeggleLevel?
    private var levelLoader = LevelLoader()
    var isLoading = false

    @IBOutlet private var levelNamesTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        levelNamesTableView.dataSource = self
        levelNamesTableView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        currentSelectedLevel = nil
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedLevel = currentSelectedLevel else {
            return
        }

        if let gameController = segue.destination as? PeggleGameController {
            gameController.peggleLevel = selectedLevel
        }

        if let designer = segue.destination as? LevelDesignerController {
            designer.peggleLevel = selectedLevel
        }
    }

}

// MARK: UITableViewDataSource
extension LevelChooserController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        levelLoader.levelCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let levelName = levelLoader.getLevelName(at: indexPath.row) else {
            fatalError("Cannot get level name with the given indexPath.")
        }

        guard let cell = tableView
                .dequeueReusableCell(
                    withIdentifier: Identifiers
                        .levelChooserViewCellId.rawValue) as? LevelChooserTableCell else {
            fatalError("Cannot get reusable cell.")
        }

        cell.levelName = levelName
        return cell
    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        guard let levelName = levelLoader.getLevelName(at: indexPath.row) else {
            fatalError("Cannot get level name with the given indexPath.")
        }

        if editingStyle == .delete {
            LevelSaver.deleteLevel(levelName: levelName)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}

// MARK: UITableViewDelegate
extension LevelChooserController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentSelectedLevel = levelLoader.getLevel(at: indexPath.row)
        if isLoading {
            performSegue(withIdentifier: Identifiers.chooserToDesigner.rawValue, sender: self)
        } else {
            performSegue(withIdentifier: Identifiers.chooserToGame.rawValue, sender: self)
        }
    }
}
