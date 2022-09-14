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
    @Environment(\.colorScheme) var colorScheme
    
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
                        Text("Hello, \(model.userName)")
                            .font(.system(.title, design: .rounded))
                            .bold()
                            .padding(40)

                        Spacer()
                        
                        if let currentUser = Auth.auth().currentUser {
                            let email = currentUser.email
                            let profileImage = model.profileImage

                            Image(uiImage: profileImage ?? UIImage())
                                .resizable()
                                .scaledToFill()
                                .frame(width: 175, height: 175)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(lineWidth: 5))
                                .padding()

                            Spacer()
                            
                            Group {
                                Text(email ?? "")
                                    .padding(.top)
                                Text(String(repeating: "•", count: model.passwordCount))
                            }.font(.system(size: 20, weight: .regular, design: .rounded))
                        }

                        Spacer()

                        NavigationLink {
                            RecipeTabView()
                        } label: {
                            ZStack {
                                Rectangle()
                                    .cornerRadius(50)
                                    .foregroundColor(colorScheme == .light ? .white : .black)
                                    .frame(height: 55)
                                    .overlay(RoundedRectangle(cornerRadius: 50)
                                        .stroke(Color.green,
                                                lineWidth: 1))
                                    .padding(40)

                                Text("Continue")
                                    .font(.system(size: 25, weight: .bold, design: .rounded))
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
