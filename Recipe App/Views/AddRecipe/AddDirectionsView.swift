//
//  AddDirectionsView.swift
//  Recipe App
//
//  Created by Ali Earp on 02/09/2022.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct AddDirectionsView: View {
    @EnvironmentObject var model: RecipeModel
    
    @State private var direction = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Add Directions")
                    .bold()
                    .font(Font.custom("Avenir Heavy", size: 24))
                
                Spacer()
                
                Button("Clear") {
                    model.directions = [String]()
                    model.addStep = false
                    model.errorMessage = ""
                }
            }
            
            TextField("Recipe Name", text: $model.recipeName)
                .multilineTextAlignment(.center)
                .font(.headline)
                .padding([.bottom, .horizontal])
            
            Text("\(model.directions.count) \(model.directions.count == 1 ? "STEP" : "STEPS")")
                .bold()
                .font(.subheadline)
                .padding(.top)
            Divider()
            
            if model.addStep == true {
                HStack {
                    TextEditor(text: $direction)
                        .frame(height: 50)
                        .padding(.bottom, 5)
                    Spacer()
                    Button {
                        let cleanedDirection = direction.trimmingCharacters(in: .whitespacesAndNewlines)
                        
                        if cleanedDirection == "" {
                            return
                        }
                        
                        model.directions.append(cleanedDirection)
                        direction = ""
                        model.addStep = false
                    } label: {
                        Text("Add")
                            .bold()
                            .foregroundColor(.green)
                            .padding(.bottom)
                    }
                }
            }
            
            VStack(alignment: .leading) {
                ScrollView(showsIndicators: false) {
                    ForEach(0..<model.directions.count, id: \.self) { index in
                        HStack(alignment: .top) {
                            if let stepNumber = index {
                                Text("\(stepNumber + 1). ")
                                    .frame(width: 25)
                                    .lineLimit(1)
                                    .font(.headline)
                                Text(model.directions[index])
                            } else {
                                Text(model.directions[index])
                            }
                            Spacer()
                            Button {
                                model.directions.remove(at: index)
                            } label: {
                                Image(systemName: "trash.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 17, height: 17)
                            }.padding(.leading)
                        }
                        .lineLimit(2)
                        .padding(.vertical, 5)
                    }
                }
            }
            
            Divider()
            
            Button {
                model.addStep = true
            } label: {
                ZStack {
                    Rectangle()
                        .cornerRadius(50)
                        .foregroundColor(.white)
                        .frame(height: 55)
                        .overlay(RoundedRectangle(cornerRadius: 50)
                            .stroke(Color.green,
                                    lineWidth: 1))
                    
                    Text("+ Add a Step")
                        .bold()
                        .foregroundColor(.green)
                }
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
            .padding(.top, 5)
        }.padding([.horizontal, .bottom])
    }
}
