//
//  AudioPlayer.swift
//  Peggle
//
//  Created by TFang on 26/2/21.
//

import AVFoundation

class AudioPlayer {
    static var musicPlayer: AVAudioPlayer?
    static var soundPlayers = [AVAudioPlayer]()
    static var bubblePlayer: AVAudioPlayer?

    static func playBackgroundMusic() {
        guard musicPlayer != nil else {
            playMusic(fileName: "bgm", loop: -1)
            return
        }
    }

    static func playInGameBgm() {
        stop()
        playMusic(fileName: "in-game-bgm", loop: -1)
    }

    static func playPauseInGameBgm() {
        guard let musicPlayer = musicPlayer else {
            return
        }
        if musicPlayer.isPlaying {
            musicPlayer.pause()
        } else {
            musicPlayer.play()
        }
    }

    static func playHitPeg() {
        playSoundOnce(fileName: "hit-peg", volume: 0.05)
    }
    static func playHitBlock() {
        playSoundOnce(fileName: "hit-block", volume: 0.15)
    }
    static func playHitBucket() {
        playSoundOnce(fileName: "hit-bucket")
    }

    static func playFireCannon() {
        playSoundOnce(fileName: "fire-cannon")
    }
    static func playSpookyBall() {
        playSoundOnce(fileName: "spooky-ball")
    }
    static func playMessageSound() {
        playSoundOnce(fileName: "message", volume: 0.05)
    }

    static func playYouWin() {
        stop()
        playSoundOnce(fileName: "you-win")
    }

    static func playGameOver() {
        stop()
        playSoundOnce(fileName: "game-over")
    }

    static func playSound(fileName: String, fileExtension: String = "mp3") {
        playMusic(fileName: fileName, loop: 1, fileExtension: fileExtension)
    }

    static func stop() {
        musicPlayer = nil
        soundPlayers = []
        bubblePlayer = nil
    }
    static func playBubbleUpSound() {
        if let bundle = Bundle.main.path(forResource: "bubble-up", ofType: "mp3") {
            let url = URL(fileURLWithPath: bundle)
            guard let player = try? AVAudioPlayer(contentsOf: url) else {
                return

            }
            bubblePlayer = player
            bubblePlayer?.volume = 0.2
            bubblePlayer?.numberOfLoops = -1
            bubblePlayer?.prepareToPlay()
            bubblePlayer?.play()
        }
    }

    static func stopBubbleUpSound() {
        bubblePlayer = nil
    }

    static func playMusic(fileName: String, loop: Int, fileExtension: String = "mp3") {
        if let bundle = Bundle.main.path(forResource: fileName, ofType: fileExtension) {
            let url = URL(fileURLWithPath: bundle)
            guard let player = try? AVAudioPlayer(contentsOf: url) else {
                return

            }

            musicPlayer = player
            musicPlayer?.volume = 0.1
            musicPlayer?.numberOfLoops = loop
            musicPlayer?.prepareToPlay()
            musicPlayer?.play()
        }
    }

    static func playSoundOnce(fileName: String, fileExtension: String = "mp3",
                              volume: Float = 0.1) {
        if let bundle = Bundle.main.path(forResource: fileName, ofType: fileExtension) {
            let url = URL(fileURLWithPath: bundle)
            guard let player = try? AVAudioPlayer(contentsOf: url) else {
                return
            }

            soundPlayers.append(player)
            player.volume = volume
            player.numberOfLoops = 0
            player.prepareToPlay()
            player.play()
        }
    }
}
