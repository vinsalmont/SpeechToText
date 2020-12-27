//
//  AudioRecorderManager.swift
//  SpeechToText
//
//  Created by Vinicius Salmont on 26/12/20.
//

import Foundation
import AVFoundation
import Combine

class AudioRecorderManager: NSObject, ObservableObject {

    override init() {
        super.init()
    }

    static let shared = AudioRecorderManager()

    let objectWillChange = PassthroughSubject<AudioRecorderManager, Never>()

    var audioRecorder: AVAudioRecorder?

    var isRecording = false {
        didSet {
            objectWillChange.send(self)
        }
    }

    var recording: Recording? = nil

    func record(failure: @escaping (() -> Void)) {
        let recordingSession = AVAudioSession.sharedInstance()

        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setCategory(.playAndRecord, mode: .default, options: [.duckOthers])
            try recordingSession.setActive(true)
        } catch {
            failure()
        }

        guard let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            failure()
            return
        }

        let audioFilename = documentPath.appendingPathComponent("speech.flac")

        let settings = [
            AVFormatIDKey: Int(kAudioFormatFLAC),
            AVSampleRateKey: 16000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue,
            AVLinearPCMBitDepthKey: 16,
            AVLinearPCMIsBigEndianKey: false,
            AVLinearPCMIsFloatKey: false,
        ] as [String : Any]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.record()

            isRecording = true
        } catch {
            failure()
        }
    }

    func stopRecording(success: @escaping ((Data) -> Void), failure: @escaping (() -> Void)) {
        audioRecorder?.stop()
        isRecording = false
        getRecord { data in
            success(data)
        } failure: {
            failure()
        }

    }

    func getRecord(success: @escaping ((Data) -> Void), failure: @escaping (() -> Void)) {
        recording = nil

        guard let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentPath, includingPropertiesForKeys: nil)

            if let audioURL = directoryContents.first {
                recording = Recording(fileURL: audioURL)
                let soundData = try Data(contentsOf: audioURL, options: Data.ReadingOptions(rawValue: 0))
                objectWillChange.send(self)
                success(soundData)
            } else {
                failure()
            }
        } catch {
            failure()
        }
    }
}
