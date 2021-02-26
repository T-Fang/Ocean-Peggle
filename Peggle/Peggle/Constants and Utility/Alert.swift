//
//  Alert.swift
//  Peggle
//
//  Created by TFang on 28/1/21.
//

import UIKit

class Alert {
    static func presentNoOrangePegAlert(controller: LevelDesignerController) {
        presentAlert(controller: controller, title: Constants.errorTitle, message: Constants.noOrangePegMessage)
    }

    static func presentCannotDeletePreloadedLevel(controller: LevelChooserController) {
        presentAlert(controller: controller, title: Constants.errorTitle,
                     message: Constants.cannotDeletePreloadedLevelMessage)
    }

    static func presentSaveLevelAlert(controller: LevelDesignerController, message: String) {
        let saveAlert = getAlertController(title: "Save", message: message)

        let levelName = controller.peggleLevel.levelName ?? "Untitled"
        guard !Constants.preloadedLevelNames.contains(levelName) else {
            presentAlert(controller: controller, title: Constants.errorTitle,
                         message: Constants.sameNameAsPreloadedLevelMessage)
            return
        }

        saveAlert.addTextField { $0.text = levelName }
        saveAlert.addAction(UIAlertAction(title: "Save", style: .default) { _ in
            guard let userInput = saveAlert.textFields?.first?.text else {
                print("Unable to get textfiled text!")
                return
            }
            checkInputAndSave(controller: controller, fileName: userInput)
        })

        saveAlert.addAction(getAction(title: Constants.cancelTitle))

        controller.present(saveAlert, animated: true)
    }

    private static func checkInputAndSave(controller: LevelDesignerController, fileName: String) {
        guard fileName.isAlphanumeric() else {
            presentSaveLevelAlert(controller: controller, message: Constants.invalidLevelName)
            return
        }

        if StorageUtility.doesFileExist(fileName: fileName) {
            presentOverwriteAlert(controller: controller, fileName: fileName)
        }

        saveLevel(controller: controller, fileName: fileName)

    }

    static func presentOverwriteAlert(controller: LevelDesignerController, fileName: String) {
        let overwriteAlert = getAlertController(
            title: Constants.levelNameExists,
            message: "Do you want to overwrite the saved level: \(fileName)?")

        overwriteAlert.addAction(UIAlertAction(title: "Overwrite", style: .default) { _ in
            saveLevel(controller: controller, fileName: fileName)
        })
        overwriteAlert.addAction(getAction(title: Constants.cancelTitle))

        controller.present(overwriteAlert, animated: true)
    }

    private static func saveLevel(controller: LevelDesignerController, fileName: String) {
        guard LevelSaver.saveLevel(peggleLevel: controller.peggleLevel, fileName: fileName) else {
            presentAlert(controller: controller, title: Constants.errorTitle, message: Constants.failedToSaveLevel)
            return
        }
    }

    private static func getAlertController(title: String, message: String) -> UIAlertController {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)

        return alertController
    }

    private static func getAction(title: String) -> UIAlertAction {
        UIAlertAction(title: title, style: .default)
    }
    private static func presentAlert(controller: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.okTitle, style: .default, handler: nil))
        controller.present(alert, animated: true)
    }
}
