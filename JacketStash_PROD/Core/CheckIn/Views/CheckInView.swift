//
//  CheckInView.swift
//  JacketStash_PROD
//
//  Created by Adam Yao on 10/19/22.
//

import SwiftUI
import StripeApplePay

struct CheckInView: View {
    @State var isChecked:Bool = false
    
    @GestureState var isDetectingLongPress = false
    @State var completedLongPress = false
    
    @GestureState var press = false
    @State var show = false
    
    @State private var isPressed = false
    
    
    var body: some View {
        VStack {
            AuthHeaderView(title1: "Hey Adam!", title2: "Let's get checked in...")
            
            //            ZStack {
            //                VStack {
            //                    Text("Hold to")
            //                    Text("confirm")
            //                }
            //            }
            
            Button(action: {
                print("hello")
            }, label: {
                Text("Check In")
                    .foregroundColor(Color.white)
            })
            .onLongPressGesture(perform: {
                print("hello")
            })
            
            .foregroundColor(.white)
            .frame(width: 60, height: 60)
            .background(Color(.systemBlue))
            .mask(Circle())
            .scaleEffect(isPressed ? 3.5 : 1)
            .pressEvents {
                withAnimation(.easeInOut(duration: 2)) {
                    isPressed = true
                    
                    
                }
            } onRelease: {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isPressed = false
                }
            }
//            .gesture(
//                LongPressGesture(minimumDuration: 0.5)
//                    .updating($press) { currentState, gestureState, transaction in
//                        gestureState = currentState
//                    }
//                    .onEnded { value in
//                        print("done pressing")
//                    }
//
//            )
            
            Spacer()
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
    
//    var swipeToConfirmButton: some View {
//        ZStack {
//            Capsule()
//                .frame(width: trackSize.width, height: trackSize.height)
//                .foregroundColor(Color.black).blendMode(.overlay).opacity(0.5)
//
//
//            Text("Swipe to confirm Check In")
//                .font(.caption)
//                .foregroundColor(Color.white)
//                .offset(x:30, y:0)
//
//            ZStack {
//                Capsule()
//                    .frame(wdith: thumbSize.width, height: thumbSize.height)
//                    .foregroundColor(Color.white)
//
//                Image(systemName: "arrow.right")
//                    .foregroundColor(Color.black)
//            }
//            .offset(x:-(trackSize.width/2 - thumbSize.width/2 - (dragOffset.width)), y:0)
//
//        }
//    }
    
    var longPress: some Gesture {
            LongPressGesture(minimumDuration: 3)
                .updating($isDetectingLongPress) { currentState, gestureState,
                        transaction in
                    gestureState = currentState
                    transaction.animation = Animation.easeIn(duration: 2.0)
                }
                .onEnded { finished in
                    self.completedLongPress = finished
                }
        }
    
    var longPressColorButton : some View {
        Button {
            print("pressing")
        } label: {
            Circle()
                .fill(self.isDetectingLongPress ? Color.red : (self.completedLongPress ? Color.green : Color.blue))
                .frame(width: 100, height: 100, alignment: .center)
                .foregroundColor(Color(.systemBlue))
                .gesture(longPress)
        }
    }
    var checkInButton : some View {
        Button {
            isChecked.toggle()
        } label: {
            HStack {
                Image(systemName: isChecked ? "checkmark.square": "square")
                Text("I understand")
            }
            .padding()
            .shadow(color: .gray.opacity(0.5), radius: 10, x:0, y:0)
        }
    }
}

