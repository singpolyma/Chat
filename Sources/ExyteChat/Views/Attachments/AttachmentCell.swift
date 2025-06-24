//
//  Created by Alex.M on 16.06.2022.
//

import SwiftUI
import SDWebImageSwiftUI

public struct AttachmentCell: View {

    @Environment(\.chatTheme) var theme

    let attachment: Attachment
    let size: CGSize
    let onTap: (Attachment) -> Void

    public init(attachment: Attachment, size: CGSize, onTap: @escaping (Attachment) -> Void) {
        self.attachment = attachment
        self.size = size
        self.onTap = onTap
    }

    public var body: some View {
        Group {
            if attachment.type == .image {
                content
            } else if attachment.type == .video {
                content
                    .overlay {
                        theme.images.message.playVideo
                            .resizable()
                            .foregroundColor(.white)
                            .frame(width: 36, height: 36)
                    }
            } else {
                content
                    .overlay {
                        Text("Unknown", bundle: .module)
                    }
            }
        }
        .frame(width: size.width, height: size.height)
        .contentShape(Rectangle())
        .simultaneousGesture(
            TapGesture().onEnded {
                onTap(attachment)
            }
        )
    }

    var content: some View {
        AsyncImageView(url: attachment.thumbnail, size: size)
    }
}

struct AsyncImageView: View {

    @Environment(\.chatTheme) var theme

    let url: URL
    let size: CGSize

    var body: some View {
        WebImage(url: url) { imageView in
            imageView
                .resizable()
                .scaledToFill()
                .frame(width: size.width, height: size.height)
                .clipped()
        } placeholder: {
            ZStack {
                Rectangle()
                    .foregroundColor(theme.colors.inputBG)
                    .frame(width: size.width, height: size.height)
                ActivityIndicator(size: 30, showBackground: false)
            }
        }
    }
}
