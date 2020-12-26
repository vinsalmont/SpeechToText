//
//  RoundedButton.swift
//  SpeechToText
//
//  Created by Vinicius Salmont on 26/12/20.
//

import SwiftUI

struct RoundedButton: View {

    let title: String
    let textColor: Color
    let backgroundColor: Color
    let iconSystemName: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                Image(systemName: iconSystemName)
                Text(title)
                    .bold()
                Spacer()
            }
        }
        .padding()
        .background(backgroundColor)
        .foregroundColor(textColor)
        .cornerRadius(40)
    }
}

struct RoundedButton_Previews: PreviewProvider {
    static var previews: some View {
        RoundedButton(title: "Title",
                      textColor: Color.white,
                      backgroundColor: Color.blue,
                      iconSystemName: "largecircle.fill.circle",
                      action: {}
        )
    }
}
