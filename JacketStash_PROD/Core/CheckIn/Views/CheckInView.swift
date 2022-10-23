//
//  CheckInView.swift
//  JacketStash_PROD
//
//  Created by Adam Yao on 10/19/22.
//

import SwiftUI

struct CheckInView: View {
//    var cb: CheckInOutButton
    @State private var isPressed = false
    @State var showingPopup = false
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack {
            AuthHeaderView(title1: "Hey Adam!", title2: "Let's get checked in...")
            
            ZStack {
                
                RoundedRectangle(cornerRadius: 50, style: .continuous)
                    .opacity(0.25)
                    .padding()
                
                Button("Push me") {
                    showingPopup = true // 2
                }
            }
//            .popover(isPresented: cb.$isCheckedIn) { // 3
//                ZStack { // 4
//                    Color.blue.frame(width: 200, height: 100)
//                    Text("Popup!")
//                }
//            }
            
            Spacer()
            
            CheckInOutButton(isDetectingLongPress: false, isCheckedIn: false, title: "Check In")
                .popover(isPresented: $authViewModel.isCheckedIn) { // 3
                    ZStack { // 4
                        Color.blue.frame(width: 200, height: 100)
                        Text("Popup!")
                    }
                }
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
                .fontWeight(.semibold)
                .font(.headline)
        }

        .padding(.bottom, 120)


    }
}
