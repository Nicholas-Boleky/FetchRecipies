//
//  EmptyStateView.swift
//  FetchRecipies
//
//  Created by Nick on 10/28/24.
//

import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack {
            Image("Kona")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .padding(.bottom)
            
            Text("No Recipes Available")
                .font(.title)
                .padding(.bottom)
            
            Text("Please pull down to refresh or try again later.")
                .multilineTextAlignment(.center)
                .padding()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
