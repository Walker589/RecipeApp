//
//  AddHighlightsView.swift
//  Recipe App
//
//  Created by Ali Earp on 13/09/2022.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct AddHighlightsView: View {
    @EnvironmentObject var model: RecipeModel
    @Environment(\.colorScheme) var colorScheme
    
    @State private var highlight = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            GeometryReader { geo in
                HStack(spacing: 0) {
                    Rectangle()
                        .foregroundColor(Color(.lightGray))
                        .frame(width: geo.size.width / 2)
                    
                    Rectangle()
                        .foregroundColor(.green)
                        .frame(width: geo.size.width / 4)
                    
                    Rectangle()
                        .foregroundColor(Color(.lightGray))
                        .frame(width: geo.size.width / 4)
                }
            }.frame(height: 5)
            
            VStack(alignment: .leading) {
                HStack {
                    Text("Add Highlights")
                        .bold()
                        .font(Font.custom("Avenir Heavy", size: 24))
                    
                    Spacer()
                    
                    Button("Clear") {
                        model.highlights = [String]()
                        model.addHighlight = false
                        model.errorMessage = ""
                    }
                }.padding(.top)
                
                TextField("Recipe Name", text: $model.recipeName)
                    .multilineTextAlignment(.center)
                    .font(.headline)
                    .padding([.bottom, .horizontal])
                
                Text("\(model.highlights.count) \(model.highlights.count == 1 ? "HIGHLIGHT" : "HIGHLIGHTS")")
                    .bold()
                    .font(.subheadline)
                    .padding(.top)
                Divider()
                
                if model.addHighlight == true {
                    HStack(alignment: .top) {
                        if #available(iOS 16.0, *) {
                            TextField("Highlight", text: $highlight, axis: .vertical)
                                .padding(.bottom, 5)
                        } else {
                            TextEditor(text: $highlight)
                                .padding(.bottom, 5)
                                .frame(height: 50)
                        }
                        
                        Spacer()
                        
                        Button {
                            let cleanedHighlight = highlight.trimmingCharacters(in: .whitespacesAndNewlines)
                            
                            if cleanedHighlight == "" {
                                return
                            }
                            
                            model.highlights.append(cleanedHighlight)
                            highlight = ""
                            model.addHighlight = false
                        } label: {
                            Text("Add")
                                .bold()
                                .foregroundColor(.green)
                        }
                    }
                }
                
                VStack(alignment: .leading) {
                    ScrollView(showsIndicators: false) {
                        ForEach(0..<model.highlights.count, id: \.self) { index in
                            HStack(alignment: .top) {
                                if let highlightNumber = index {
                                    Text("\(highlightNumber + 1). ")
                                        .frame(width: 25)
                                        .lineLimit(1)
                                        .font(.headline)
                                    Text(model.highlights[index])
                                } else {
                                    Text(model.highlights[index])
                                }
                                Spacer()
                                Button {
                                    model.highlights.remove(at: index)
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
                    model.addHighlight = true
                } label: {
                    ZStack {
                        Rectangle()
                            .cornerRadius(50)
                            .foregroundColor(colorScheme == .light ? .white : .black)
                            .frame(height: 55)
                            .overlay(RoundedRectangle(cornerRadius: 50)
                                .stroke(Color.green,
                                        lineWidth: 1))
                        
                        Text("+ Add a Highlight")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.green)
                    }
                }
                .padding([.horizontal, .bottom], 40)
                .padding(.top)
            }.padding([.horizontal, .bottom])
        }
    }
}
