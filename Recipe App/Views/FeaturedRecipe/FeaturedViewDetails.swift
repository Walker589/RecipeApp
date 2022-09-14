//
//  FeaturedViewDetails.swift
//  Recipe App
//
//  Created by Ali Earp on 22/08/2022.
//

import SwiftUI

struct FeaturedViewDetails: View {
    var title: String
    var info: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(Font.custom("Avenir Heavy", size: 16))
            Text(info)
                .font(Font.custom("Avenir", size: 15))
        }
    }
}
