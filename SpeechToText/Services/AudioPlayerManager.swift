//
//  AudioPlayerManager.swift
//  SpeechToText
//
//  Created by Vinicius Salmont on 26/12/20.
//

import Foundation
import Combine
import AVFoundation

class AudioPlayerManager: NSObject, ObservableObject {

    static let shared = AudioPlayerManager()

    let objectWillChange = PassthroughSubject<AudioPlayerManager, Never>()
    private var timeObserverToken: Any?

    var isPlaying = false {
        didSet {
            objectWillChange.send(self)
        }
    }

    var currentTimestamp: Double = 0.0 {
        didSet {
            objectWillChange.send(self)
        }
    }

    var audioPlayer: AVPlayer?

    func play(audio: URL, failure: @escaping (() -> Void)) {

        let playbackSession = AVAudioSession.sharedInstance()

        do {
            try playbackSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
            try playbackSession.setCategory(
                AVAudioSession.Category.playback,
                mode: AVAudioSession.Mode.default,
                options: [
                    AVAudioSession.CategoryOptions.duckOthers
                ]
            )
        } catch {
            failure()
        }

        audioPlayer = AVPlayer(url: audio)

        audioPlayer?.play()
        isPlaying = true

        NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying(sender:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)

        let interval = CMTime(seconds: 0.100, preferredTimescale: CMTimeScale(NSEC_PER_MSEC))
        timeObserverToken = self.audioPlayer?.addPeriodicTimeObserver(forInterval: interval, queue: .main, using: { [weak self] _ in
            guard let self = self else { return }
            self.currentTimestamp = self.audioPlayer?.currentTime().seconds ?? 0.0
        })
    }

    @objc private func playerDidFinishPlaying(sender: Notification) {
        isPlaying = false
    }

    func stop() {
        audioPlayer?.seek(to: CMTime.zero)
        audioPlayer?.pause()
        isPlaying = false
        self.currentTimestamp = 0.0
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            isPlaying = false
            self.currentTimestamp = 0.0
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        if let token = timeObserverToken {
            self.audioPlayer?.removeTimeObserver(token)
            timeObserverToken = nil
        }
    }
}
