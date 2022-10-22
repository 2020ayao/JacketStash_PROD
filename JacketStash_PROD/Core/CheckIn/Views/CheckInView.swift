//
//  CheckInView.swift
//  JacketStash_PROD
//
//  Created by Adam Yao on 10/19/22.
//

import SwiftUI
import StripeApplePay

struct CheckInView: View {
    
    @GestureState var isDetectingLongPress = false
    @State var isCheckedIn = false
    
    @State private var isPressed = false
    
    
    var body: some View {
        VStack {
            AuthHeaderView(title1: "Hey Adam!", title2: "Let's get checked in...")
            
            Spacer()
            
            checkInButton
        }
        .ignoresSafeArea()
    }
}


struct CheckInView_Previews: PreviewProvider {
    static var previews: some View {
        CheckInView()
    }
}

extension CheckInView {
    
    var longPress: some Gesture {
        LongPressGesture(minimumDuration: 3)
            .updating($isDetectingLongPress) { currentState, gestureState,
                transaction in
                gestureState = currentState
                transaction.animation = Animation.easeIn(duration: 2.0)
            }
            .onEnded { finished in
                self.isCheckedIn = true
                print("DEBUG: Checked In")
            }
    }
    
    var checkInButton : some View {
        ZStack {
            Circle()
                .fill(Color(.systemBlue))
                .frame(width: 100, height: 100)
                .scaleEffect(isPressed ? 2 : 0.99)
                .animation(.easeIn(duration: 1.5), value: isPressed)
            Circle()
                .fill(Color(.white))
                .frame(width: 100, height: 100)
                .scaleEffect(isPressed ? 1.99 : 0.5)
                .animation(.easeOut(duration: 3), value: isPressed)
                .gesture(longPress)
            
            
            Button {
//                if self.checkedIn {
//                    print("DEBUG: CHECKED IN")
//                }
            } label: {
                Text("")
            }
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
                .fontWeight(.semibold)
                .font(.headline)
            
        }
        
        .padding(.bottom, 150)
    }
}

