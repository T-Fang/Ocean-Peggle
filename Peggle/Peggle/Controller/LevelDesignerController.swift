//
//  LevelDesignerController.swift
//  Peggle
//
//  Created by TFang on 26/1/21.
//

import UIKit

class LevelDesignerController: UIViewController {
    var peggleLevel = PeggleLevel()

    private var pegViews: [Peg: PegView] = [:]
    private var selectedPeggleObject: PeggleObject? {
        willSet {
            if let currentSelectedPeg = selectedPeggleObject as? Peg {
                pegViews[currentSelectedPeg]?.unselect()
            }
            if let newlySelectedPeg = newValue as? Peg {
                pegViews[newlySelectedPeg]?.select()
            }
        }
    }

    private var selectedPaletteButton: PaletteButton? {
        willSet {
            if let selectedPaletteButton = selectedPaletteButton {
                selectedPaletteButton.unselect()
            }
            if let newlySelectedPaletteButton = newValue {
                newlySelectedPaletteButton.select()
            }
        }
    }

    private var isOscillating = false
    @IBAction private func toggleOscillationMode() {
        isOscillating.toggle()
    }

    @IBOutlet private var gameBoardView: GameBoardView!

    @IBOutlet private var bluePegButton: PaletteButton!
    @IBOutlet private var orangePegButton: PaletteButton!
    @IBOutlet private var greenPegButton: PaletteButton!
    @IBOutlet private var blockButton: PaletteButton!
    @IBOutlet private var eraseButton: PaletteButton!

    @IBOutlet private var widthSlider: UISlider!
    var blockWidth: CGFloat {
        let width = CGFloat(widthSlider.value)
            * (Constants.maxBlockWidth - Constants.minBlockWidth) + Constants.minBlockWidth
        print(width)
        return width
    }

    @IBOutlet private var loadButton: UIButton!
    @IBOutlet private var saveButton: UIButton!
    @IBOutlet private var resetButton: UIButton!

    @IBOutlet private var bluePegCountLabel: UILabel!
    @IBOutlet private var orangePegCountLabel: UILabel!
    @IBOutlet private var greenPegCountLabel: UILabel!

    override var prefersStatusBarHidden: Bool {
        true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadGameBoard()
        setUpPaletteButtons()
    }

    private func setUpPaletteButtons() {
        bluePegButton.setUpPegButton(color: .blue, shape: .circle)
        orangePegButton.setUpPegButton(color: .orange, shape: .circle)
        greenPegButton.setUpPegButton(color: .green, shape: .circle)
        eraseButton.setUp(type: .erase)
        blockButton.setUp(type: .block)

        selectedPaletteButton = bluePegButton
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == Identifiers.designerToGame.rawValue {
            guard peggleLevel.hasOrangePeg else {
                Alert.presentNoOrangePegAlert(controller: self)
                return false
            }
        }
        return true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let gameController = segue.destination as? PeggleGameController {
            gameController.peggleLevel = peggleLevel
        }

        if let chooser = segue.destination as? LevelChooserController {
            chooser.isLoading = true
        }
    }

    @IBAction private func handleSingleTap(_ sender: UITapGestureRecognizer) {
        let tapPosition = sender.location(in: gameBoardView)

        switch selectedPaletteButton?.type {
        case .erase:
            peggleLevel.removePeg(at: tapPosition)
        case .block:
            // TODO
            if let existingObject = peggleLevel.getObjectThatContains(tapPosition) {
                selectedPeggleObject = existingObject
                return
            }
            peggleLevel.addBlock(at: tapPosition, width: 0, height: 0)
        case .peg:
            if let existingObject = peggleLevel.getObjectThatContains(tapPosition) {
                selectedPeggleObject = existingObject
                return
            }
            guard let shape = selectedPaletteButton?.shape,
                  let color = selectedPaletteButton?.color else {
                return
            }
            // TODO
            peggleLevel.addPeg(at: tapPosition, shape: shape, color: color,
                               period: isOscillating ? 2 : nil)
        case nil:
            return
        }
        loadGameBoard()
    }

    @IBAction private func handlePan(_ sender: UIPanGestureRecognizer) {
        let tapPosition = sender.location(in: gameBoardView)

        switch sender.state {
        case .began:
            selectedPeggleObject = peggleLevel.getObjectThatContains(tapPosition)
        case .changed:
            handleDragChanged(sender)
        default:
            return
        }

    }
    private func handleDragChanged(_ sender: UIPanGestureRecognizer) {
        guard let selectedObject = selectedPeggleObject else {
            return
        }

        let newPosition = sender.location(in: gameBoardView)

        guard let movedObject = peggleLevel.moveObject(selectedObject, to: newPosition) else {
            return
        }

        loadGameBoard()
        selectedPeggleObject = movedObject
    }

    @IBAction private func handleLongPress(_ sender: UILongPressGestureRecognizer) {
        let tapPosition = sender.location(in: gameBoardView)

        peggleLevel.removePeg(at: tapPosition)
        loadGameBoard()
    }

    @IBAction private func handlePinch(_ sender: UIPinchGestureRecognizer) {
        guard let object = selectedPeggleObject else {
            return
        }

        let scale = sender.scale
        sender.scale = 1

        guard let resizedObject = peggleLevel.resizeObject(object, by: scale) else {
            return
        }

        loadGameBoard()
        selectedPeggleObject = resizedObject
    }

    @IBAction private func handleRotation(_ sender: UIRotationGestureRecognizer) {
        guard let object = selectedPeggleObject else {
            return
        }

        let rotation = sender.rotation
        sender.rotation = .zero

        guard let rotatedObject = peggleLevel.rotateObject(object, by: rotation) else {
            return
        }

        loadGameBoard()
        selectedPeggleObject = rotatedObject
    }

    private func loadGameBoard() {
        gameBoardView.resetBoard()
        pegViews = [:]
        peggleLevel.pegs.forEach { peg in
            let pegView = DisplayUtility.generatePegView(for: peg)
            gameBoardView.addPegView(pegView)
            pegViews[peg] = pegView
        }
        selectedPeggleObject = nil

        displayPegCounts()
    }

    private func displayPegCounts() {
        guard let blueCirclePegCount = peggleLevel.getPegCounts()[.circle]?[.blue],
              let orangeCirclePegCount = peggleLevel.getPegCounts()[.circle]?[.orange],
              let greenCirclePegCount = peggleLevel.getPegCounts()[.circle]?[.green] else {
            return
        }

        bluePegCountLabel.text = String(blueCirclePegCount)
        orangePegCountLabel.text = String(orangeCirclePegCount)
        greenPegCountLabel.text = String(greenCirclePegCount)
    }

}

// MARK: Button Actions
extension LevelDesignerController {
    @IBAction private func handleBluePegButtonTap(_ sender: UIButton) {
        selectedPaletteButton = bluePegButton
    }
    @IBAction private func handleOrangePegButtonTap(_ sender: UIButton) {
        selectedPaletteButton = orangePegButton
    }
    @IBAction private func handleGreenPegButtonTap(_ sender: UIButton) {
        selectedPaletteButton = greenPegButton
    }

    @IBAction private func handleBlockButtonTap(_ sender: UIButton) {
        selectedPaletteButton = blockButton
    }
    @IBAction private func handleEraseButtonTap(_ sender: UIButton) {
        selectedPaletteButton = eraseButton
    }

    @IBAction private func saveLevel(_ sender: UIButton) {
        guard peggleLevel.hasOrangePeg else {
            Alert.presentNoOrangePegAlert(controller: self)
            return
        }
        Alert.presentSaveLevelAlert(controller: self, message: Constants.saveLevelMessage)

    }

    @IBAction private func resetLevel(_ sender: UIButton) {
        peggleLevel.resetPegBoard()
        loadGameBoard()
    }

}

extension LevelDesignerController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        gestureRecognizer is UIRotationGestureRecognizer
            && otherGestureRecognizer is UIPinchGestureRecognizer
    }
}
