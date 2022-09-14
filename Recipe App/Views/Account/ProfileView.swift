//
//  ProfileView.swift
//  Recipe App
//
//  Created by Ali Earp on 13/09/2022.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @EnvironmentObject var model: RecipeModel
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            Text("\(model.userName)'s Profile")
                .font(.system(.largeTitle, design: .rounded))
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
            
            Button {
                do {
                    try Auth.auth().signOut()
                    model.checkLogin()
                } catch {
                    print(error.localizedDescription)
                }
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

                    Text("Sign Out")
                        .font(.system(size: 25, weight: .bold, design: .rounded))
                        .foregroundColor(.green)
                }
            }.padding()
            
            Spacer()
        }
    }
}
