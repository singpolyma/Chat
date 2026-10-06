//
//  Created by Alex.M on 14.06.2022.
//

import SwiftUI

struct TextInputView: View {
    
    @Environment(\.chatTheme) private var theme
    
    @EnvironmentObject private var globalFocusState: GlobalFocusState

    @Binding var text: String
    @Binding var attributedText: AttributedString
    var inputFieldId: UUID
    var style: InputViewStyle
    var availableInputs: [AvailableInputType]
    var localization: ChatLocalization
    @State private var textSize: CGSize = .zero
    
    var body: some View {
        let editor = if #available(iOS 26.0, *) {
            TextEditor(text: $attributedText)
        } else {
            TextEditor(text: $text)
        }
        let textForSize = if #available(iOS 26.0, *) {
            Text(attributedText)
        } else {
            Text(text)
        }
        ZStack(alignment: .leading) {
            editor.customFocus($globalFocusState.focus, equals: .uuid(inputFieldId))
                .foregroundColor(style == .message ? theme.colors.inputText : theme.colors.inputSignatureText)
                .padding(.vertical, 0)
                .frame(height: min(max(textSize.height, 30), 120))
                .scrollContentBackground(.hidden)
                .simultaneousGesture(
                    TapGesture().onEnded {
                        globalFocusState.focus = .uuid(inputFieldId)
                    }
                )
            if text == "" && attributedText == "" {
                Text(style == .message ? localization.inputPlaceholder : localization.signatureText)
                    .allowsHitTesting(false)
                    .foregroundColor(style == .message ? theme.colors.inputPlaceholderText : theme.colors.inputSignaturePlaceholderText)
            }
        }
        .background(
            textForSize
                .opacity(0)
                .foregroundColor(.clear)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.vertical, 8)
                .padding(.leading, 10)
                .sizeGetter($textSize)
        )
        .padding(.leading, !isMediaGiphyAvailable() ? 12 : 0)
    }
    
    private func isMediaGiphyAvailable() -> Bool {
        return availableInputs.contains(AvailableInputType.media)
        || availableInputs.contains(AvailableInputType.giphy)
    }
}

