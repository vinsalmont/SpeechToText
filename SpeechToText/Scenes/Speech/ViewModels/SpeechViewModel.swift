//
//  SpeechViewModel.swift
//  SpeechToText
//
//  Created by Vinicius Salmont on 26/12/20.
//

import SwiftUI
import Combine

class SpeechViewModel: ObservableObject {
    @Published var isRecording = false
    @Published var isPlaying = false
    @Published var secondsPlayed = 0.0
    @Published var speechedText = ""
    @Published var loading = false
    @Published var error = false
    @Published var highlitedWord = ""

    private var recordSubscriber: AnyCancellable?
    private var playingSubscriver: AnyCancellable?
    private var timestamps = [WordTimeStamp]()

    init() {
        recordSubscriber = AudioRecorderManager.shared.objectWillChange.sink { (manager) in
            self.isRecording = manager.isRecording
        }

        playingSubscriver = AudioPlayerManager.shared.objectWillChange.sink { (manager) in
            self.isPlaying = manager.isPlaying
            self.highlitedWord = self.highlitedText()
            self.secondsPlayed = manager.currentTimestamp
        }
    }

    deinit {
        recordSubscriber?.cancel()
        playingSubscriver?.cancel()
    }

    func record() {
        AudioRecorderManager.shared.record {
            DispatchQueue.main.async {
                self.error = true
            }
        }
    }

    func stopRecording() {
        DispatchQueue.main.async {
            self.loading = true
        }
        AudioRecorderManager.shared.stopRecording { data in
            SpeechManager.shared.getText(from: data) { (alternatives) in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }

                    guard
                        let alternative = alternatives.first else { return }
                    let transcript = alternative.transcript
                    self.timestamps = alternative.words ?? []

                    DispatchQueue.main.async {
                        self.speechedText = transcript
                        self.loading = false
                        self.error = false
                    }
                }
            } failure: {
                DispatchQueue.main.async {
                    self.loading = false
                    self.error = true
                }
            }
        } failure: {
            DispatchQueue.main.async {
                self.loading = false
                self.error = true
            }
        }

    }

    func playRecord() {
        guard let fileUrl = AudioRecorderManager.shared.recording?.fileURL else { return }
        AudioPlayerManager.shared.play(audio: fileUrl) {
            DispatchQueue.main.async {
                self.error = true
            }
        }
    }

    func stopPlaying() {
        AudioPlayerManager.shared.stop()
    }

    func highlitedText() -> String {
        var word = ""
        timestamps.forEach { time in
            let startTime = time.startTimeInSeconds()
            let endTime = time.endTimeInSeconds()

            if  secondsPlayed >= startTime && secondsPlayed < endTime {
                word = time.word
            }
        }

        return word
    }
}
