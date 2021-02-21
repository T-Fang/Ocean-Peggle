//
//  PeggleGameController.swift
//  Peggle
//
//  Created by TFang on 11/2/21.
//

import UIKit

class PeggleGameController: UIViewController {
    // engine is guaranteed to be initialized in viewWillAppear
    private var engine: GameEngine!
    // peggleLevel is guaranteed to be initialized in segue preperation
    var peggleLevel: PeggleLevel!
    private var selectedMaster = Master.Splork
    private var pegToView = [GamePeg: PegView]()

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

    override var prefersStatusBarHidden: Bool {
        true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        gameBoardView.addBucket()
        masterChooserTableView.dataSource = self
        masterChooserTableView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpGameEngine()
        reloadLevel()

        if peggleLevel.hasGreenPeg() {
            masterChooserTableView.isHidden = false
            engine.pause()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        engine.updateFrame(frame: gameBoardView.frame)
    }

    private func setUpGameBoard() {
        loadPegViews()
        cannonView.resetCannon()
        gameEndView.hide()
    }

    private func setUpGameEngine() {
        engine = GameEngine(frame: gameBoardView.frame, peggleLevel: peggleLevel)
        engine.delegate = self
    }

    private func loadPegViews() {
        gameBoardView.resetBoard()
        engine.objects.forEach { gamePeg in
            let pegView = PegView(shape: gamePeg.shape, color: gamePeg.color, frame: gamePeg.frame)
            pegToView[gamePeg] = pegView
            gameBoardView.addPegView(pegView)
        }
    }
}

// MARK: GameEventHandlerDelegate
extension PeggleGameController: GameEventHandlerDelegate {
    func didHitBucket() {
        // TODO: Add hit bucket sound
    }

    func showMessage(_ message: String) {
        self.messageLabel.alpha = 1.0
        self.messageLabel.text = message

        UIView.animate(withDuration: Constants.messageLabelAnimationDuration,
                       delay: 0.0,
                       options: .curveEaseOut,
                       animations: { self.messageLabel.alpha = 0.0 })
    }

    func willRemovePegs(gamePegs: [GamePeg]) {
        gamePegs.forEach { gamePeg in
            pegToView[gamePeg]?.fade()
            pegToView[gamePeg] = nil
        }
    }

    func ballDidMove(ball: Ball) {
        gameBoardView.moveBall(to: ball.center)
    }

    func didRemoveBall() {
        gameBoardView.removeBall()

        switch gameState {
        case .win:
            gameEndView.showYouWin()
        case .lose:
            gameEndView.showGameOver()
        default:
            return
        }
    }

    func didHitPeg(gamePeg: GamePeg) {
        pegToView[gamePeg]?.glow()
    }

    func ballCountDidChange(ballCount: Int) {
        ballCountLabel.text = String(ballCount)
    }

    func orangePegCountDidChange(orangePegCount: Int) {
        orangePegCountLabel.text = String(orangePegCount)
    }

    func bucketDidMove(bucket: Bucket) {
        gameBoardView.moveBucket(to: bucket.center)
    }
}

// MARK: Gestures
extension PeggleGameController {
    @IBAction private func rotateCannon(_ sender: UIPanGestureRecognizer) {
        guard gameState == .onGoing else {
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
        engine.launchBall(at: cannonView.center, angle: cannonView.angle)
        gameBoardView.launchBall(at: cannonView.center)
    }

}

// MARK: Button Actions
extension PeggleGameController {
    @IBAction private func reloadLevel() {
        engine.reset()
        setUpGameBoard()
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
        selectedMaster = Master.allMasters[indexPath.row]
        engine.resume()
        masterChooserTableView.isHidden = true
    }
}
