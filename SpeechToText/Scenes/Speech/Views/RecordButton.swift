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
            title: getTitle(),
            textColor: Color.white,
            backgroundColor: getBackgroudColor(),
            iconSystemName: getIcon(),
            action: action
        ).accessibility(label: Text(getTitle()))
    }

    private func getTitle() -> String {
        return isRecording ? "Stop Recording" : "Record"
    }

    private func getBackgroudColor() -> Color {
        return isRecording ? Color.red : Color.blue
    }

    private func getIcon() -> String {
        return isRecording ? "stop.fill" :  "largecircle.fill.circle"
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
