//
//  LaunchPage.swift
//  Recipe App
//
//  Created by Ali Earp on 13/09/2022.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

struct LaunchPage: View {
    @EnvironmentObject var model: RecipeModel
    
    let storage = Storage.storage()
    
    var body: some View {
        if model.loggedIn == false {
            LoginView()
                .onAppear {
                    model.checkLogin()
                }
        } else {
            NavigationView {
                if model.profileImage != nil {
                    VStack {
                        Text("\(model.loginMode == true ? "Welcome Back," : "Welcome,") \(model.userName)")
                            .font(.system(.title, design: .rounded))
                            .bold()
                            .padding(40)

                        if let currentUser = Auth.auth().currentUser {
                            let email = currentUser.email
                            let profileImage = model.profileImage

                            Image(uiImage: profileImage ?? UIImage())
                                .resizable()
                                .scaledToFill()
                                .frame(width: 175, height: 175)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(.black, lineWidth: 5))
                                .padding()

                            Group {
                                Text(email ?? "")
                                    .padding(.top)
                                Text(String(repeating: "•", count: model.passwordCount))
                            }.font(.headline)
                        }

                        Spacer()

                        NavigationLink {
                            RecipeTabView()
                        } label: {
                            ZStack {
                                Rectangle()
                                    .cornerRadius(50)
                                    .foregroundColor(.white)
                                    .frame(height: 55)
                                    .overlay(RoundedRectangle(cornerRadius: 50)
                                        .stroke(Color.green,
                                                lineWidth: 1))
                                    .padding(40)

                                Text("Continue")
                                    .bold()
                                    .foregroundColor(.green)
                            }
                        }.padding()

                        Spacer()
                    }
                } else {
                    ProgressView()
                }
            }.onAppear {
                model.getRemoteData()
                model.getUserData()
                model.getProfileImage()
            }
        }
    }
}
