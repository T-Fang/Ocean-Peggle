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
    private var blockViews: [Block: BlockView] = [:]
    private var selectedPeggleObject: PeggleObject? {
        willSet {
            if let currentSelectedPeg = selectedPeggleObject as? Peg {
                pegViews[currentSelectedPeg]?.unselect()
            }
            if let newlySelectedPeg = newValue as? Peg {
                pegViews[newlySelectedPeg]?.select()
            }
            if let currentSelectedBlock = selectedPeggleObject as? Block {
                blockViews[currentSelectedBlock]?.unselect()
            }
            if let newlySelectedBlock = newValue as? Block {
                blockViews[newlySelectedBlock]?.select()
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

    @IBOutlet private var gameBoardView: GameBoardView!

    @IBOutlet private var bluePegButton: PaletteButton!
    @IBOutlet private var orangePegButton: PaletteButton!
    @IBOutlet private var greenPegButton: PaletteButton!
    @IBOutlet private var blockButton: PaletteButton!
    @IBOutlet private var eraseButton: PaletteButton!

    var blockWidth: CGFloat = (Constants.minBlockWidth + Constants.maxBlockWidth) / 2
    var blockHeight: CGFloat = (Constants.minBlockHeight + Constants.maxBlockHeight) / 2
    var period: CGFloat = (Constants.minPeriod + Constants.maxPeriod) / 2

    @IBOutlet private var loadButton: UIButton!
    @IBOutlet private var saveButton: UIButton!
    @IBOutlet private var resetButton: UIButton!

    @IBOutlet private var blueCirclePegCountLabel: UILabel!
    @IBOutlet private var orangeCirclePegCountLabel: UILabel!
    @IBOutlet private var greenCirclePegCountLabel: UILabel!

    @IBOutlet private var blueTrianglePegCountLabel: UILabel!
    @IBOutlet private var orangeTrianglePegCountLabel: UILabel!
    @IBOutlet private var greenTrianglePegCountLabel: UILabel!

    @IBOutlet private var periodSlider: UISlider!

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

    @IBAction private func loadLevel(_ segue: UIStoryboardSegue) {
        if let chooser = segue.source as? LevelChooserController {
            guard let selectedLevel = chooser.currentSelectedLevel else {
                return
            }
            self.peggleLevel = selectedLevel
            loadGameBoard()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let gameController = segue.destination as? PeggleGameController {
            gameController.peggleLevel = peggleLevel
        }

        if let chooser = segue.destination as? LevelChooserController {
            chooser.isLoading = true
        }
    }

    var isObjectDetected: Bool?
    var startLocation: CGPoint?
    @IBAction private func handlePan(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            isObjectDetected = detectObject(sender)
            startLocation = sender.location(in: gameBoardView)
        case .changed:
            guard let isObject = isObjectDetected,
                  let object = selectedPeggleObject,
                  let start = startLocation else {
                return
            }
            if isObject {
                moveObject(sender)
                return
            }
            let isStartOnTheRight = object.isPointOnTheRight(start)
            let location = sender.location(in: gameBoardView)
            let isOnTheRight = object.isPointOnTheRight(location)

            guard isOnTheRight == isStartOnTheRight else {
                flipHandle()
                startLocation = location
                return
            }

            let centerToLocation = CGVector.generateVector(from: object.center, to: location)
            let component = abs(centerToLocation.componentOn(object.vectorTowardRight))
            let newLength = component - object.vectorTowardRight.norm
            moveHandle(isRightHandle: isOnTheRight, newLength: newLength)
        case .ended:
            isObjectDetected = nil
            startLocation = nil
        default:
            return
        }

    }

    private func detectObject(_ sender: UIPanGestureRecognizer) -> Bool? {
        let tapPosition = sender.location(in: gameBoardView)

        guard let object = peggleLevel.getObject(at: tapPosition) else {
            guard let objectWithHandle = peggleLevel
                    .getHandleOrObject(at: tapPosition) else {
                selectedPeggleObject = nil
                return nil
            }
            selectedPeggleObject = objectWithHandle
            return false
        }
        selectedPeggleObject = object
        return true
    }
    private func flipHandle() {
        guard let selectedObject = selectedPeggleObject else {
            return
        }

        guard let newObject = peggleLevel.flipHandleOf(selectedObject) else {
            return
        }

        loadGameBoard()
        selectedPeggleObject = newObject
    }
    private func moveHandle(isRightHandle: Bool, newLength: CGFloat) {
        guard let selectedObject = selectedPeggleObject, newLength >= 0 else {
            return
        }

        guard let newObject = peggleLevel.changeHandleLengthOf(
                selectedObject, isRightHandle: isRightHandle, newLength: newLength) else {
            return
        }

        loadGameBoard()
        selectedPeggleObject = newObject
    }
    private func moveObject(_ sender: UIPanGestureRecognizer) {
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

    private func loadGameBoard() {
        gameBoardView.resetBoard()
        loadPegs()
        loadBlocks()
        selectedPeggleObject = nil
        displayPegCounts()
    }
    private func loadPegs() {
        pegViews = [:]
        peggleLevel.pegs.forEach { peg in
            let pegView = DisplayUtility.getPegView(for: peg)
            gameBoardView.addPegView(pegView)
            pegViews[peg] = pegView
        }
    }
    private func loadBlocks() {
        blockViews = [:]
        peggleLevel.blocks.forEach { block in
            let blockView = DisplayUtility.getBlockView(for: block)
            gameBoardView.addBlockView(blockView)
            blockViews[block] = blockView
        }
    }

    private func displayPegCounts() {
        guard let blueCirclePegCount = peggleLevel.getPegCounts()[.circle]?[.blue],
              let orangeCirclePegCount = peggleLevel.getPegCounts()[.circle]?[.orange],
              let greenCirclePegCount = peggleLevel.getPegCounts()[.circle]?[.green],
              let blueTrianglePegCount = peggleLevel.getPegCounts()[.triangle]?[.blue],
              let orangeTrianglePegCount = peggleLevel.getPegCounts()[.triangle]?[.orange],
              let greenTrianglePegCount = peggleLevel.getPegCounts()[.triangle]?[.green] else {
            return
        }

        blueCirclePegCountLabel.text = String(blueCirclePegCount)
        orangeCirclePegCountLabel.text = String(orangeCirclePegCount)
        greenCirclePegCountLabel.text = String(greenCirclePegCount)
        blueTrianglePegCountLabel.text = String(blueTrianglePegCount)
        orangeTrianglePegCountLabel.text = String(orangeTrianglePegCount)
        greenTrianglePegCountLabel.text = String(greenTrianglePegCount)
    }

}
// MARK: Gestures
extension LevelDesignerController {

    @IBAction private func changeBlockWidth(_ sender: UISlider) {
        blockWidth = CGFloat(sender.value)
            * (Constants.maxBlockWidth - Constants.minBlockWidth) + Constants.minBlockWidth
    }

    @IBAction private func changeBlockHeight(_ sender: UISlider) {
        blockHeight = CGFloat(sender.value)
            * (Constants.maxBlockHeight - Constants.minBlockHeight) + Constants.minBlockHeight
    }

    @IBAction private func changePeriod(_ sender: UISlider) {
        period = CGFloat(sender.value)
            * (Constants.maxPeriod - Constants.minPeriod) + Constants.minPeriod
    }

    @IBAction private func handleSingleTap(_ sender: UITapGestureRecognizer) {
        let tapPosition = sender.location(in: gameBoardView)

        switch selectedPaletteButton?.type {
        case .erase:
            peggleLevel.removeObject(at: tapPosition)
        case .block:
            if let existingObject = peggleLevel.getHandleOrObject(at: tapPosition) {
                selectedPeggleObject = existingObject
                return
            }
            peggleLevel.addBlock(at: tapPosition, width: blockWidth, height: blockHeight,
                                 period: isOscillating ? period : nil)
        case .peg:
            if let existingObject = peggleLevel.getHandleOrObject(at: tapPosition) {
                selectedPeggleObject = existingObject
                return
            }
            guard let shape = selectedPaletteButton?.shape,
                  let color = selectedPaletteButton?.color else {
                return
            }
            peggleLevel.addPeg(at: tapPosition, shape: shape, color: color,
                               period: isOscillating ? period : nil)
        case nil:
            return
        }
        loadGameBoard()
    }

    @IBAction private func handleLongPress(_ sender: UILongPressGestureRecognizer) {
        let tapPosition = sender.location(in: gameBoardView)

        peggleLevel.removeObject(at: tapPosition)
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
}
// MARK: Button/Switch Actions
extension LevelDesignerController {

    @IBAction private func toggleShape() {
        bluePegButton.toggleShape()
        orangePegButton.toggleShape()
        greenPegButton.toggleShape()
    }

    @IBAction private func toggleOscillationMode() {
        isOscillating.toggle()
        periodSlider.isEnabled.toggle()
        periodSlider.isHighlighted.toggle()
    }

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

// MARK: UIGestureRecognizerDelegate
extension LevelDesignerController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        gestureRecognizer is UIRotationGestureRecognizer
            && otherGestureRecognizer is UIPinchGestureRecognizer
    }
}
