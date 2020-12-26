//
//  HomeView.swift
//  SpeechToText
//
//  Created by Vinicius Salmont on 26/12/20.
//

import SwiftUI

struct HomeView: View {

    @ObservedObject private var speechViewModel = SpeechViewModel()

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Spacer()

            Text("1. Rercord, 2.View transcribed text, 3. Play back audio with text highlgh")
                .padding(.horizontal, 20)
                .font(.footnote)

            Spacer()

            VStack {
                Text(self.speechViewModel.speechedText)
                    .border(Color.black, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                Spacer()
            }


            HStack {
                RecordButton(
                    isRecording: self.speechViewModel.isRecording,
                    action: {
                        self.speechViewModel.isRecording ? speechViewModel.stopRecording() : speechViewModel.record()
                    }
                )
                PlayButton(
                    isPlaying: self.speechViewModel.isPlaying,
                    action: {
                        self.speechViewModel.isPlaying ? speechViewModel.stopPlaying() : speechViewModel.playRecord()
                    }
                )
            }

        }.padding()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
