//
//  CheckInView.swift
//  JacketStash_PROD
//
//  Created by Adam Yao on 10/19/22.
//

import SwiftUI

struct CheckInView: View {
    //    var cb: CheckInOutButton
//    @State private var isPressed = false
    //@State var showingPopup = false
    @EnvironmentObject var authViewModel: AuthViewModel
    @ObservedObject var viewModel = CheckedInViewModel()
    @ObservedObject var vModel = CheckInNotifViewModel()
    
    @State var checkedIn = false
    @State var checkedOut = false
    
    var body: some View {
        if let user = authViewModel.currentUser {
            ZStack(alignment: .bottom){
                //let _ = print(user.fullname)
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.feed) { feed in
                            CheckInNotifView(feed: feed, viewModel: vModel)
                                .padding()
                        }
                    }
                }
                .refreshable {
                    viewModel.fetchFeed()
                }
                if user.isCheckedIn == false {
                        CheckInOutButton(checkIn: $checkedIn, title: "Check In")
                        .sheet(isPresented: $checkedIn, content: {
                            checkOutConfirmation
                                
                            })
                            .offset(y:100)
                            .presentationDetents([.fraction(0.35)])

                        
                    }
                else {
                    CheckInOutButton(checkIn: $checkedIn, title: "Check Out")
                        .sheet(isPresented: $checkedIn, content: {
                            checkInConfirmation
                        })
                        .offset(y:100)
                        .presentationDetents([.fraction(0.35)])
                }
            }
        }
        else {
            Button {
                try! authViewModel.signOut()
            } label: {
                Text("Sign Out")
            }
        }

    }
    
    func toggleStatus() {
        checkedIn.toggle()
    }
}


struct CheckInView_Previews: PreviewProvider {
    static var previews: some View {
        CheckInView()
            .environmentObject(AuthViewModel())
    }
}

extension CheckInView {
    
    var checkOutConfirmation : some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .padding()
                .padding(.top, 30)
                .foregroundColor(Color.mint)
            //.frame(width: 200, height: 150)
            VStack {
                ZStack {
                    Circle()
                        .foregroundColor(Color.white)
                        .frame(width: 50, height: 50)
                    Circle()
                        .foregroundColor(Color.mint)
                        .frame(width: 45, height: 45)
                    Image(systemName: "checkmark")
                }
                .offset(y:25)
                
                VStack(spacing:10) {
                    Text("Thank you for using JacketStash!")
                        .fontWeight(.semibold)
                        .font(.system(size: 20))
                        .offset(y:20)
                    if let user = authViewModel.currentUser {
//                        let _ = print("The current coat_id is:  ")
                        Text("Coat ID: # \(user.coat_id)")
                            .fontWeight(.semibold)
                            .font(.headline)
                            .offset(y:20)
                    }
                }
                Spacer()
            }
        }
        .presentationDetents([.fraction(0.35)])
    }
    
    var checkInConfirmation : some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .padding()
                .padding(.top, 30)
                .foregroundColor(Color.mint)
            //.frame(width: 200, height: 150)
            VStack {
            ZStack {
                Circle()
                    .foregroundColor(Color.white)
                    .frame(width: 50, height: 50)
                Circle()
                    .foregroundColor(Color.mint)
                    .frame(width: 45, height: 45)
                Image(systemName: "checkmark")
            }
            .offset(y:25)
            
            VStack(spacing:10) {
                Text("Thank you for checking in! ")
                    .fontWeight(.semibold)
                    .font(.title)
                    .offset(y:20)
                if let coat_id = authViewModel.currentUser?.coat_id {
                    Text("Your coat ID for the night is # \(coat_id)")
                        .fontWeight(.semibold)
                        .font(.headline)
                        .offset(y:20)
                }
            }
            Spacer()
        }
        
        
    }
    .presentationDetents([.fraction(0.35)])
    }
}



