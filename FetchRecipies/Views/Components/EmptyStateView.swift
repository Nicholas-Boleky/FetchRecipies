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
            Text("No Recipes Available")
                .font(.title)
                .padding(.bottom)
            Text("Please pull down to refresh or try again later.")
                .multilineTextAlignment(.center)
                .padding()
        }
        .padding()
    }
}
