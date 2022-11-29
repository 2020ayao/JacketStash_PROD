//
//  EditProfileView.swift
//  JacketStash_PROD
//
//  Created by Adam Yao on 11/14/22.
//

import SwiftUI
import Kingfisher

struct EditProfileView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var email = ""
    @State private var fullname = ""
    @State private var username = ""
    @State private var disabled = true
    @EnvironmentObject var viewModel: AuthViewModel
    
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var profileImage: Image?

    var body: some View {
        if let user = viewModel.currentUser {
            VStack {
                Button {
                    showImagePicker.toggle()
                } label: {
                    if let profileImage = profileImage {
                        profileImage
                            .resizable()
                            .modifier(ProfileImageModifier())
                        
                    }
                    else {
                        KFImage(URL(string: user.profileImageUrl))
                            .resizable()
                            .modifier(ProfileImageModifier())
                    }
                    
                }
                .sheet(isPresented: $showImagePicker, onDismiss: loadImage) {
                    ImagePicker(selectedImage: $selectedImage)
                }
//                .overlay(alignment: .bottomTrailing, content: {
//                    Image(systemName: "photo").foregroundColor(Color(.systemBlue)).frame(alignment: .bottomTrailing).offset(x:-20)
//                })
                .padding(.top, 44)
                
                
                
                
                
                VStack(spacing: 10) {
                    CustomTextBox(placeholderText: "Email", isSecureField: false, text: .constant(user.email), disabled: $disabled).padding(.bottom, 20).disabled(true).opacity(0.7)
                    CustomTextBox(placeholderText: "Username", text: $username, disabled: $disabled)
                    CustomTextBox(placeholderText: "Full Name", text: $fullname, disabled: $disabled)
                }
                .onAppear {
                    //                    self.email = user.email
                    self.fullname = user.fullname
                    self.username = user.username
                }
                
                
                
                .padding(.horizontal,15)
                .padding(.top, 44)
                Spacer()
                Button {
                    if let selectedImage = selectedImage {
                        
                        //                viewModel.login(withEmail: email, password: password)
                        //should go and update the information
                        
                        viewModel.updateProfileInformation(withUid: viewModel.userSession!.uid, withName: fullname, withUserName: username, withSelectedImage: selectedImage)
                        print(user.fullname)
                        presentationMode.wrappedValue.dismiss()
                    }
                    else {
                        viewModel.updateProfileInformation(withUid: viewModel.userSession!.uid, withName: fullname, withUserName: username)
                        print(user.fullname)
                        presentationMode.wrappedValue.dismiss()
                    }
                    
                    
                } label: {
                    Text("Save")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 340, height: 50)
                        .background(disabled ? Color(.gray) : Color(.systemBlue))
                        .clipShape(Capsule())
                        .padding()
                }
                .shadow(color: .gray.opacity(0.5), radius: 10, x:0, y:0)
                .disabled(disabled)
                
            }
            .onTapGesture {
                hideKeyboard()
            }
            
        }
            
        
    }
    func loadImage() {
        guard let selectedImage = selectedImage else {return}
        profileImage = Image(uiImage: selectedImage)
        disabled = false
    }
}

extension EditProfileView {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}

private struct ProfileImageModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color(.systemBlue))
            .scaledToFill()
            .frame(width:200, height: 200)
            .clipShape(Circle())
    }
}

//struct EditProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditProfileView()
//    }
//}
