//
//  CheckInView.swift
//  JacketStash_PROD
//
//  Created by Adam Yao on 10/19/22.
//

import SwiftUI
import StripeApplePay

struct CheckInView: View {
    @State var isCheckedIn = false
    
    var body: some View {
        VStack {
            AuthHeaderView(title1: "Hey Adam!", title2: "Let's get checked in...")
            
            Spacer()
            
            CheckInOutButton(isDetectingLongPress: false, isCheckedIn: false, title: "Check In")
        }
        .ignoresSafeArea()
    }
}


struct CheckInView_Previews: PreviewProvider {
    static var previews: some View {
        CheckInView()
    }
}

<<<<<<< HEAD

=======
extension CheckInView {
    
    var checkInButton : some View {
        ZStack {
            Circle()
                .fill(Color(.systemBlue))
                .frame(width: 100, height: 100)
                .scaleEffect(isPressed ? 2 : 0.99)
                .animation(.easeIn(duration: 1.5), value: isPressed)
                //.animation(.easeOut(duration: 0.5), value: isPressed)
            
            Circle()
                .fill(Color(.white))
                .frame(width: 100, height: 100)
                .scaleEffect(isPressed ? 1.99 : 0.5)
                .animation(.easeOut(duration: 3), value: isPressed)
            
            Button(action: {
                print("hello")
            }, label: {})
            .onLongPressGesture(perform: {
                print("hello")
            })
            .frame(width: 100, height: 100)
            .background(Color(.systemBlue))
            .mask(Circle())
            
            .pressEvents {
                withAnimation(.easeIn(duration: 2.75)) {
                    isPressed = true
                }
            
            } onRelease: {
                withAnimation(.easeOut(duration: 0.5)) {
                    isPressed = false
                }
            }
            Text("Check In")
                .foregroundColor(.white)
        }
        
        .padding(.bottom, 120)
        
        
    }
}
>>>>>>> parent of d408034 (Position and text font edits)

