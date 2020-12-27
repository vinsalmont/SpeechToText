//
//  AttributedTextView.swift
//  SpeechToText
//
//  Based on https://www.reddit.com/r/SwiftUI/comments/intmd7/nsattributedstring_in_swiftui/g4at0u4/?utm_source=share&utm_medium=ios_app&utm_name=iossmf
//

import SwiftUI

struct AttributedTextFromFileView: UIViewRepresentable {
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    let fullText: String
    let highlightedText: String

    func makeUIView(context: Context) -> UITextView {
        let uiTextView = UITextView()
        uiTextView.isEditable = false

        uiTextView.attributedText = attributedText()

        return uiTextView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {

        uiView.attributedText = attributedText()
    }

    private func attributedText() -> NSAttributedString {
        let attributed: NSMutableAttributedString = .init(string: fullText)

        let stringRange = attributed.mutableString.range(of: fullText)
        let highlightedTextRange = attributed.mutableString.range(of: highlightedText)

        attributed.addAttributes([
            .font: UIFont.preferredFont(forTextStyle: .largeTitle),
            .foregroundColor: colorScheme == .light ?  UIColor.black : UIColor.white
        ], range: stringRange)

        attributed.addAttributes([
            .backgroundColor: UIColor.purple,
            .foregroundColor: UIColor.white,
        ], range: highlightedTextRange)

        return attributed
    }
}


struct AttributedTextFromFileView_Previews: PreviewProvider {
    static let lorem = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed imperdiet condimentum facilisis. Morbi gravida, massa et malesuada venenatis, elit nisl aliquam nisi, sed fermentum massa libero id leo. Integer pellentesque nunc sit amet sem suscipit, sit amet imperdiet nibh facilisis. Nunc quis leo vitae ipsum tempor condimentum eget in massa. Nam ut ultrices neque, iaculis sodales urna. Nulla facilisi. Vivamus dictum mauris sed pretium tempor. Phasellus maximus semper mauris in porttitor. Sed a turpis risus."

    static var previews: some View {
        AttributedTextFromFileView(fullText: lorem, highlightedText: "quis")
            .padding(.horizontal, 40)
    }
}
