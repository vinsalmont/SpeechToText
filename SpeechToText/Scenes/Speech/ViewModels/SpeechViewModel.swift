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
    @Published var speechedText = ""
    @Published var error = false

    private var recordSubscriber: AnyCancellable?
    private var playingSubscriver: AnyCancellable?

    init() {

        recordSubscriber = AudioRecorderManager.shared.objectWillChange.sink { (manager) in
            self.isRecording = manager.isRecording
        }

        playingSubscriver = AudioPlayerManager.shared.objectWillChange.sink { (manager) in
            self.isPlaying = manager.isPlaying
        }
    }

    deinit {
        recordSubscriber?.cancel()
        playingSubscriver?.cancel()
    }

    func record() {
        AudioRecorderManager.shared.record {
            self.error = true
        }
    }

    func stopRecording() {
        // TODO CAll speech api
        AudioRecorderManager.shared.stopRecording { data in
            SpeechManager.shared.getText(from: data) { (alternatives) in
                DispatchQueue.main.async {
                    guard let transcript = alternatives.first?.transcript else { return }
                    self.speechedText = transcript
                }
            } failure: {
                DispatchQueue.main.async {
                    self.error = true
                }
            }
        } failure: {

        }

    }

    func playRecord() {
        AudioPlayerManager.shared.play(audio: AudioRecorderManager.shared.recording!.fileURL) {
            self.error = true
        }
    }

    func stopPlaying() {
        AudioPlayerManager.shared.stop()
    }

}
