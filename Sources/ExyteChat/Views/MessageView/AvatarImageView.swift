//
//  Created by Alex.M on 07.07.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct AvatarImageView: View {

    let url: URL?
    let placeholder: URL?
    let avatarSize: CGFloat
    var avatarCacheKey: String? = nil

    var body: some View {
        WebImage(url: url) { image in
            image
                .resizable()
                .scaledToFill()
        } placeholder: {
            if let placeholder {
		WebImage(url: placeholder)
            } else {
                Rectangle().fill(Color.gray)
            }
        }
        .viewSize(avatarSize)
        .clipShape(Circle())
    }
}

struct AvatarImageView_Previews: PreviewProvider {
    static var previews: some View {
        AvatarImageView(
            url: URL(string: "https://placeimg.com/640/480/sepia"),
            placeholder: nil,
            avatarSize: 32
        )
    }
}
