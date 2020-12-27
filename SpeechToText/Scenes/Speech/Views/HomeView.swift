//
//  HomeView.swift
//  SpeechToText
//
//  Created by Vinicius Salmont on 26/12/20.
//

import SwiftUI

struct HomeView:  View {
    @ObservedObject private var speechViewModel = SpeechViewModel()
    @State var play = 1

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Spacer()

            Text("1. Rercord, 2.View transcribed text, 3. Play back audio with text highlight")
                .font(.footnote)

            Spacer()

            VStack {
                HStack {
                    Spacer()
                }
                if self.speechViewModel.loading {
                    HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
                        LottieView(name: "loading", play: $play)
                            .frame(width: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .accessibility(label: Text("Loading"))
                    }
                } else if self.speechViewModel.error {
                    HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
                        LottieView(name: "error", play: $play)
                            .frame(width: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .accessibility(label: Text("An error ocurred while trying to process the audio, try again!"))
                    }
                } else {
                    AttributedTextFromFileView(fullText: self.speechViewModel.speechedText, highlightedText: self.speechViewModel.highlitedWord)
                        .accessibility(label: Text(self.speechViewModel.speechedText))
                }

                Spacer()
            }.border(Color.black, width: 0.5)

            Spacer(minLength: 10)

            HStack {
                RecordButton(
                    isRecording: self.speechViewModel.isRecording,
                    action: {
                        self.speechViewModel.isRecording ? speechViewModel.stopRecording() : speechViewModel.record()
                    }
                )
                PlayButton(
                    isPlaying: self.speechViewModel.isPlaying,
                    isEnabled: !self.speechViewModel.isRecording && !self.speechViewModel.speechedText.isEmpty,
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
