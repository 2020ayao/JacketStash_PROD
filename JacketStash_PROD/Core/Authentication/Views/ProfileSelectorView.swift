//
//  ProfileSelectorView.swift
//  JacketStash_PROD
//
//  Created by Adam Yao on 11/6/22.
//

import SwiftUI

struct ProfileSelectorView: View {
    @Binding var email: String
    @Binding var username: String
    @Binding var fullname: String
    @Binding var password: String
    
    
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var profileImage: Image?
    
    @State private var disabled = false
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {
        VStack {
            AuthHeaderView(title1: "Last step!", title2: "Select a profile image")
            
            Button {
                showImagePicker.toggle()
            } label: {
                if let profileImage = profileImage {
                    profileImage
                        .resizable()
                        .modifier(ProfileImageModifier())

                }else {
                    Image(systemName: "plus.circle")
                        .renderingMode(.template)
                        .modifier(ProfileImageModifier())
                        .font(.system(size: 150))
                }

            }
            .sheet(isPresented: $showImagePicker, onDismiss: loadImage) {
                ImagePicker(selectedImage: $selectedImage)
            }
            .padding(.top, 44)

            
            if let selectedImage = selectedImage {
                
                Button {
                    viewModel.register(withEmail: email, password: password, fullname: fullname, username: username, isCheckedIn: false, selectedImage: selectedImage)
                    //                    viewModel.uploadProfileImage(selectedImage)
                    disabled = true
                    
                }
            label: {
                Text("Sign Up")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 340, height: 50)
                    .background(disabled ? Color(.gray) : Color(.systemBlue))
                    .clipShape(Capsule())
                    .padding()
                    
                
            }
            .disabled(disabled)
            .shadow(color: .gray.opacity(0.5), radius: 10, x:0, y:0)
            
            }
                
            
            if let err = viewModel.err {
                Text(err)
                    .padding()
                    .onAppear {
                        disabled = false
                    }
            }
            
                
            
            Spacer()
        }
        .onAppear {
            viewModel.err = nil
            disabled = false
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
                    .navigationBarItems(leading: Button(action : {
                        self.mode.wrappedValue.dismiss()
                    }){
                        Image(systemName: "arrow.left")
                            .foregroundColor(.white)
                    })
//        .navigationBarBackButtonHidden(true)

        
    }
    
    func loadImage() {
        guard let selectedImage = selectedImage else {return}
        profileImage = Image(uiImage: selectedImage)
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

//struct ProfileSelectorView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileSelectorView()
//    }
//}


