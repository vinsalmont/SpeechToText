//
//  PlayButton.swift
//  SpeechToText
//
//  Created by Vinicius Salmont on 26/12/20.
//

import SwiftUI

struct PlayButton: View {

    let isPlaying: Bool
    let action: () -> Void

    var body: some View {
        RoundedButton(
            title: isPlaying ? "Pause" : "Play", textColor: Color.white,
            backgroundColor: isPlaying ? Color.red : Color.blue,
            iconSystemName: isPlaying ? "pause.fill" :  "play.fill",
            action: action
        )
    }
}

struct PlayButton_Previews: PreviewProvider {
    static var previews: some View {
        PlayButton(isPlaying: false,
                   action: {})
    }
}
