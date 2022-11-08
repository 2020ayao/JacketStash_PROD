//
//  AvatarViewPicker.swift
//  JacketStash_PROD
//
//  Created by Adam Yao on 11/7/22.
//

import SwiftUI

struct AvatarViewPicker: View {
    let color: Color
    var body: some View {
        Button {
//            self.userSession = user

        } label: {
            Circle()
                .foregroundColor(color)
        }
    }
}

struct AvatarViewPicker_Previews: PreviewProvider {
    static var previews: some View {
        AvatarViewPicker(color: .primary)
    }
}
