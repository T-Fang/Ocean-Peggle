//
//  PeggleGameController.swift
//  Peggle
//
//  Created by TFang on 11/2/21.
//

import UIKit

class PeggleGameController: UIViewController {
    // engine and renderer is guaranteed to be initialized after master selection
    private var engine: GameEngine!
    private var renderer: PeggleGameRenderer!
    // peggleLevel is guaranteed to be initialized in segue preperation
    var peggleLevel: PeggleLevel!

    var gameState: State {
        engine.gameStatus.state
    }

    @IBOutlet private var masterChooserTableView: UITableView!
    @IBOutlet private var gameBoardView: GameBoardView!
    @IBOutlet private var gameEndView: GameEndView!
    @IBOutlet private var cannonView: CannonView!

    @IBOutlet private var messageLabel: UILabel!
    @IBOutlet private var ballCountLabel: UILabel!
    @IBOutlet private var orangePegCountLabel: UILabel!
    @IBOutlet private var floatBubblePercentLabel: UILabel!

    @IBOutlet private var scoreLabel: UILabel!
    @IBOutlet private var timeLeftLabel: UILabel!

    override var prefersStatusBarHidden: Bool {
        true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        gameBoardView.isUserInteractionEnabled = false

        masterChooserTableView.dataSource = self
        masterChooserTableView.delegate = self
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        engine.stopDisplayLink()
    }
}

// MARK: GameEventHandlerDelegate
extension PeggleGameController: GameEventHandlerDelegate {
    func floatBubbleDidRunOut() {
        engine.unfloatBall()
    }

    func floatBubbleDidChange(percentage: Double) {
        floatBubblePercentLabel.text = String(format: "%.1f%", percentage)
    }

    func scoreDidChange(score: Int) {
        scoreLabel.text = String(score)
    }

    func objectsDidMove() {
        renderer.render(on: gameBoardView)
    }

    func didActivateSpaceBlast(at center: CGPoint) {
        gameBoardView.bubbleEffect(at: center)
    }
    func didActivateSpookyBall() {
        AudioPlayer.playSpookyBall()
    }

    func didHitPeg() {
        AudioPlayer.playHitPeg()
    }

    func didHitBlock() {
        AudioPlayer.playHitBlock()
    }
    func didHitBucket() {
        AudioPlayer.playHitBucket()
    }

    func showMessage(_ message: String) {
        AudioPlayer.playMessageSound()
        self.messageLabel.alpha = 1.0
        self.messageLabel.text = message

        UIView.animate(withDuration: Constants.messageLabelAnimationDuration,
                       delay: 0.0,
                       options: .curveEaseInOut,
                       animations: { self.messageLabel.alpha = 0.0 })
    }

    func willRemovePeg(gamePeg: GamePeg) {
        gameBoardView.removeObjectEffect(objectView: DisplayUtility.getPegView(for: gamePeg))
    }
    func willRemoveBlock(gameBlock: GameBlock) {
        gameBoardView.removeObjectEffect(objectView: DisplayUtility
                                            .getBlockView(for: gameBlock))
    }

    func timeDidChange(time: Float) {
        timeLeftLabel.text = String(format: "%.2fs", time)
        checkEndGame()
    }

    func didRemoveBall() {
        gameBoardView.removeBall()
        checkEndGame()
    }
    private func checkEndGame() {
        switch gameState {
        case .win:
            AudioPlayer.playYouWin()
            gameEndView.showYouWin()
        case .lose:
            AudioPlayer.playGameOver()
            gameEndView.showGameOver()
        default:
            return
        }
    }

    func ballCountDidChange(ballCount: Int) {
        ballCountLabel.text = String(ballCount)
    }

    func orangePegCountDidChange(orangePegCount: Int) {
        orangePegCountLabel.text = String(orangePegCount)
    }
}

// MARK: Gestures
extension PeggleGameController {

    @IBAction private func floatBall(_ sender: UILongPressGestureRecognizer) {
        sender.minimumPressDuration = 0.1
        switch sender.state {
        case .began:
            engine.floatBall()
        case .ended:
            engine.unfloatBall()
        default:
            return
        }
    }

    @IBAction private func rotateCannon(_ sender: UIPanGestureRecognizer) {
        guard engine != nil, gameState != .paused else {
            return
        }

        let dy = sender.location(in: gameBoardView).y - cannonView.center.y
        let dx = sender.location(in: gameBoardView).x - cannonView.center.x
        let piOverTwo = CGFloat(Double.pi / 2)
        let angle = atan2(dy, dx) - piOverTwo

        guard angle <= piOverTwo, angle >= -piOverTwo else {
            return
        }

        cannonView.rotate(to: angle)
    }

    @IBAction private func fireCannon(_ sender: UITapGestureRecognizer) {
        guard engine.canFire else {
            return
        }

        AudioPlayer.playFireCannon()
        engine.launchBall(at: cannonView.center, angle: cannonView.angle)
    }

}

// MARK: Button Actions
extension PeggleGameController {

    @IBAction private func playPause() {
        engine.playPause()
        AudioPlayer.playPauseInGameBgm()
    }

    @IBAction private func reloadLevel() {
        guard engine != nil else {
            return
        }
        engine.reset()
        renderer.render(on: gameBoardView)
        cannonView.resetCannon()
        gameEndView.hide()

        AudioPlayer.playInGameBgm()
    }
}

// MARK: UITableViewDataSource
extension PeggleGameController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Master.allMasters.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let master = Master.allMasters[indexPath.row]
        guard let cell = tableView
                .dequeueReusableCell(
                    withIdentifier: Identifiers
                        .masterChooserViewCellId.rawValue) as? MasterChooserTableCell else {
            fatalError("Cannot get reusable cell.")
        }

        cell.setUp(master: master)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.masterChooserTableCellHeight
    }

}

// MARK: UITableViewDelegate
extension PeggleGameController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        setUpGameEngine(master: Master.allMasters[indexPath.row])
        reloadLevel()

        masterChooserTableView.isHidden = true
        gameBoardView.isUserInteractionEnabled = true
    }

    private func setUpGameEngine(master: Master) {
        engine = GameEngine(frame: gameBoardView.frame, peggleLevel: peggleLevel, master: master)
        engine.delegate = self
        renderer = PeggleGameRenderer(engine: engine)
    }
}
