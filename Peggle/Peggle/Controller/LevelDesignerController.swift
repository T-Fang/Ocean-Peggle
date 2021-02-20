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
    private var currentSelectedPeg: Peg? {
        willSet {
            if let currentSelectedPeg = currentSelectedPeg {
                pegViews[currentSelectedPeg]?.dim()
            }
            if let newlySelectedPeg = newValue {
                pegViews[newlySelectedPeg]?.glow()
            }
        }
    }

    private var currentSelectedPegButton: PegButton? {
        willSet {
            if let currentSelectedPegButton = currentSelectedPegButton {
                currentSelectedPegButton.unselect()
            }
            if let newlySelectedPegButton = newValue {
                newlySelectedPegButton.select()
            }
        }
    }

    @IBOutlet private var gameBoardView: GameBoardView!

    @IBOutlet private var bluePegButton: PegButton!
    @IBOutlet private var orangePegButton: PegButton!

    @IBOutlet private var eraseButton: PegButton!

    @IBOutlet private var loadButton: UIButton!
    @IBOutlet private var saveButton: UIButton!
    @IBOutlet private var resetButton: UIButton!

    @IBOutlet private var bluePegCountLabel: UILabel!
    @IBOutlet private var orangePegCountLabel: UILabel!

    override var prefersStatusBarHidden: Bool {
        true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadGameBoard()
        setUpPegButtons()
    }

    private func setUpPegButtons() {
        bluePegButton.setUp(color: .blue, shape: .circle)
        orangePegButton.setUp(color: .orange, shape: .circle)

        currentSelectedPegButton = bluePegButton
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == Identifiers.designerToGame.rawValue {
            guard peggleLevel.hasOrangePeg() else {
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

        guard let shape = currentSelectedPegButton?.shape,
              let color = currentSelectedPegButton?.color else {
            peggleLevel.removePeg(at: tapPosition)
            loadGameBoard()
            return
        }

        if let existingPeg = peggleLevel.getPegThatContains(tapPosition) {
            currentSelectedPeg = existingPeg
            return
        }

        peggleLevel.addPeg(at: tapPosition, shape: shape, color: color)
        loadGameBoard()
    }

    var startingPosition: CGPoint?
    @IBAction private func handlePan(_ sender: UIPanGestureRecognizer) {
        let tapPosition = sender.location(in: gameBoardView)

        switch sender.state {
        case .began:
            startingPosition = tapPosition
        case .changed:
            handleDragChanged(sender)
        case .ended:
            startingPosition = nil
        default:
            return
        }

    }
    private func handleDragChanged(_ sender: UIPanGestureRecognizer) {
        guard let startingPosition = startingPosition else {
            return
        }

        let translation = sender.translation(in: gameBoardView)
        let newPosition = startingPosition.offsetBy(x: translation.x, y: translation.y)

        guard let movedPeg = peggleLevel.movePeg(from: startingPosition, to: newPosition) else {
            return
        }

        loadGameBoard()
        currentSelectedPeg = movedPeg

        self.startingPosition = newPosition
        sender.setTranslation(CGPoint.zero, in: gameBoardView)
    }

    @IBAction private func handleLongPress(_ sender: UILongPressGestureRecognizer) {
        let tapPosition = sender.location(in: gameBoardView)

        peggleLevel.removePeg(at: tapPosition)
        loadGameBoard()
    }

    @IBAction private func handlePinch(_ sender: UIPinchGestureRecognizer) {
        guard let peg = currentSelectedPeg else {
            return
        }

        let scale = sender.scale
        sender.scale = 1

        guard let resizedPeg = peggleLevel.resizePeg(peg: peg, by: scale) else {
            return
        }

        loadGameBoard()
        currentSelectedPeg = resizedPeg
    }

    private func loadGameBoard() {
        gameBoardView.resetBoard()
        pegViews = [:]
        peggleLevel.pegs.forEach { peg in
            let pegView = PegView(shape: peg.shape,
                                  color: peg.color,
                                  frame: peg.frame)
            gameBoardView.addPegView(pegView)
            pegViews[peg] = pegView
        }

        displayPegCounts()
    }

    private func displayPegCounts() {
        guard let blueCirclePegCount = peggleLevel.getPegCounts()[.circle]?[.blue],
              let orangeCirclePegCount = peggleLevel.getPegCounts()[.circle]?[.orange] else {
            return
        }

        bluePegCountLabel.text = String(blueCirclePegCount)
        orangePegCountLabel.text = String(orangeCirclePegCount)
    }

}

// MARK: Button Actions
extension LevelDesignerController {
    @IBAction private func handleBluePegButtonTap(_ sender: UIButton) {
        currentSelectedPegButton = bluePegButton
    }

    @IBAction private func handleOrangePegButtonTap(_ sender: UIButton) {
        currentSelectedPegButton = orangePegButton
    }

    @IBAction private func handleErasePegButtonTap(_ sender: UIButton) {
        currentSelectedPegButton = eraseButton
    }

    @IBAction private func saveLevel(_ sender: UIButton) {
        guard peggleLevel.hasOrangePeg() else {
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
