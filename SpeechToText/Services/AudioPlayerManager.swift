//
//  AudioPlayerManager.swift
//  SpeechToText
//
//  Created by Vinicius Salmont on 26/12/20.
//

import Foundation
import Combine
import AVFoundation

class AudioPlayerManager: NSObject, ObservableObject, AVAudioPlayerDelegate {

    static let shared = AudioPlayerManager()

    let objectWillChange = PassthroughSubject<AudioPlayerManager, Never>()

    var isPlaying = false {
        didSet {
            objectWillChange.send(self)
        }
    }

    var audioPlayer: AVAudioPlayer?

    func play(audio: URL, failure: @escaping (() -> Void)) {

        let playbackSession = AVAudioSession.sharedInstance()

        do {
            try playbackSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch {
            failure()
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audio)
            audioPlayer?.delegate = self
            audioPlayer?.play()
            isPlaying = true
        } catch {
            failure()
        }
    }

    func stop() {
        audioPlayer?.stop()
        isPlaying = false
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            isPlaying = false
        }
    }
}
