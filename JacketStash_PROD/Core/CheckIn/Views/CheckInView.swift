//
//  CheckInView.swift
//  JacketStash_PROD
//
//  Created by Adam Yao on 10/19/22.
//

import SwiftUI

struct CheckInView: View {
    var body: some View {
        VStack {
            Text("Check In View")
            
            Button(action: {})
            {
                Text("A Button")
            }
            .simultaneousGesture(
                LongPressGesture()
                    .onEnded { _ in
                        print("Loooong")
                    }
            )
            .highPriorityGesture(TapGesture()
                .onEnded { _ in
                    print("Tap")
                })
            
        }
    }
}

struct CheckInView_Previews: PreviewProvider {
    static var previews: some View {
        CheckInView()
    }
}
