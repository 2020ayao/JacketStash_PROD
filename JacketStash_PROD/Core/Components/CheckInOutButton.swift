//
//  checkInOutButton.swift
//  JacketStash_PROD
//
//  Created by Adam Yao on 10/21/22.
//

import SwiftUI
import AudioToolbox

struct CheckInOutButton: View {
    //@State var checkingIn: Bool
    @Binding var checkIn: Bool
    @State private var isPressed = false
    @GestureState var isDetectingLongPress = false
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var viewModel: CheckedInViewModel
    let title: String
    
    var body: some View {
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
                
                
                Text(title)
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                    .font(.headline)
                    .gesture(longPress)
                    .pressEvents(onPress: {
                        isPressed = true
                    }, onRelease: {
                        isPressed = false
                    })
                
            }
            
            .padding(.bottom, 150)
        }
}

//struct CheckInOutButton_Previews: PreviewProvider {
//    static var previews: some View {
//        CheckInOutButton(checkingIn: true, title: "Check In")
//    }
//}

extension CheckInOutButton {
    var longPress: some Gesture {
        LongPressGesture(minimumDuration: 2.9, maximumDistance: .infinity)
            .updating($isDetectingLongPress) { currentState, gestureState,
                transaction in
                gestureState = currentState
                transaction.animation = Animation.easeIn(duration: 2.0)
            }
            .onEnded { finished in
                AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) {   }
                guard let uid = authViewModel.userSession?.uid else {return}
                if let user = authViewModel.currentUser {
                    if user.isCheckedIn == false {
                        // if ((authViewModel.currentUser?.isCheckedIn) != nil){
                        authViewModel.checkIn()
                        authViewModel.updateCheckInStatus(update: true, withUid: uid, coat_id: user.coat_id)                      
                        checkIn.toggle()
                        
                    }
                    else {
                        authViewModel.checkOut()
//                        viewModel.updateCheckInStatus(withUid: uid)
                        authViewModel.updateCheckInStatus(update: false, withUid: uid, coat_id: user.coat_id)
                        //                        CheckInView().checkedOut = true
                        checkIn.toggle()
                    }
                    authViewModel.fetchUser()
                    
                }
            }
    }
    
}
