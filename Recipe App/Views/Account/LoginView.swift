//
//  LoginView.swift
//  LearningApp
//
//  Created by Ali Earp on 26/08/2022.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct LoginView: View {
    @EnvironmentObject var model: RecipeModel
    
    @State private var isShowingImagePicker = false
    @State private var recipeImage: UIImage?
    @State private var image = Image(systemName: "person.circle")
    
    @State var loginMode = true
    @State var email = ""
    @State var name = ""
    @State var password = ""
    @State var errorMessage: String?
    
    var buttonText: String {
        if loginMode == true {
            return "Login"
        } else {
            return "Create Account"
        }
    }
    
    var body: some View {
        VStack(spacing: 10) {
            Spacer()
            
            if loginMode == false {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 175, height: 175)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(.black, lineWidth: 5))
                    .padding(.top)
                    .onTapGesture {
                        isShowingImagePicker = true
                    }
                    .sheet(isPresented: $isShowingImagePicker, onDismiss: loadImage) {
                        ImagePicker(recipeImage: $recipeImage)
                    }
                    .padding()
            }
            
            Text("Recipe App")
                .font(.system(.largeTitle, design: .rounded))
                .bold()
                .padding()
            
            Spacer()
            
            Picker(selection: $loginMode, label: Text("Picker")) {
                Text("Login")
                    .tag(true)
                Text("Create Account")
                    .tag(false)
            }.pickerStyle(SegmentedPickerStyle())
            
            Group {
                TextField("Email", text: $email)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                if loginMode == false {
                    TextField("Name", text: $name)
                }
                SecureField("Password", text: $password)
            }
            
            if let errorMessage = errorMessage {
                Text(errorMessage).foregroundColor(.red)
            }
            
            Button {
                if email != "" && password != "" {
                    if loginMode == true {
                        Auth.auth().signIn(withEmail: email, password: password) { result, error in
                            guard error == nil else {
                                errorMessage = error!.localizedDescription
                                return
                            }
                            
                            self.errorMessage = nil
                            model.checkLogin()
                        }
                    } else {
                        if recipeImage != nil {
                            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                                guard error == nil else {
                                    errorMessage = error!.localizedDescription
                                    return
                                }
                                
                                self.errorMessage = nil
                                model.uploadImage(image: recipeImage!, name: "profile image", profileImage: true)
                                model.uploadUserData(name: name, passwordCount: password.count)
                                model.loginMode = false
                                model.checkLogin()
                            }
                        }
                    }
                }
            } label: {
                ZStack {
                    Rectangle()
                        .foregroundColor(.blue)
                        .frame(height: 48)
                        .cornerRadius(10)
                    Text(buttonText)
                        .foregroundColor(.white)
                }
            }
            
            Spacer()
        }
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .padding(.horizontal, 40)
    }
    
    func loadImage() {
        if recipeImage != nil {
            image = Image(uiImage: recipeImage!)
        }
    }
}
