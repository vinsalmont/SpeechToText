//
//  PlayButton.swift
//  SpeechToText
//
//  Created by Vinicius Salmont on 26/12/20.
//

import SwiftUI

struct PlayButton: View {

    let isPlaying: Bool
    let isEnabled: Bool
    let action: () -> Void

    var body: some View {
        RoundedButton(
            title: getTitle(),
            textColor: Color.white,
            backgroundColor: getBackgroudColor(),
            iconSystemName: getIcon(),
            action: action
        ).accessibility(label: Text(getTitle()))
        .disabled(!isEnabled)
    }

    private func getTitle() -> String {
        return isPlaying ? "Stop" : "Play"
    }

    private func getBackgroudColor() -> Color {
        return  isPlaying ? Color.red : Color.blue
    }

    private func getIcon() -> String {
        return isPlaying ? "stop.fill" :  "play.fill"
    }
}

struct PlayButton_Previews: PreviewProvider {
    static var previews: some View {
        PlayButton(isPlaying: false,
                   isEnabled: true,
                   action: {})
    }
}
