//
//  AddListData.swift
//  Recipe App
//
//  Created by Ali Earp on 31/08/2022.
//

import SwiftUI

struct AddListData: View {
    @Binding var list: [String]
    @State private var item: String = ""
    
    var title: String
    var placeholderText: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("\(title): ").bold()
                TextField(placeholderText, text: $item)
                Spacer()
                Button("Add") {
                    // Add item
                    if item.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                        list.append(item.trimmingCharacters(in: .whitespacesAndNewlines))
                        item = ""
                    }
                }
            }
            
            ForEach(list, id: \.self) { item in
                Text(item)
            }
        }
    }
}
