//
//  RecordButton.swift
//  SpeechToText
//
//  Created by Vinicius Salmont on 26/12/20.
//

import SwiftUI

struct RecordButton: View {

    let isRecording: Bool
    let action: () -> Void

    var body: some View {
        RoundedButton(
            title: isRecording ? "Stop Recording" : "Record", textColor: Color.white,
            backgroundColor: isRecording ? Color.red : Color.blue,
            iconSystemName: isRecording ? "stop.fill" :  "largecircle.fill.circle",
            action: action
        )
    }
}

struct RecordButton_Previews: PreviewProvider {
    static var previews: some View {
        RecordButton(
            isRecording: false,
            action: {
            }
        )
    }
}
