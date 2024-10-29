//
//  ErrorView.swift
//  FetchRecipies
//
//  Created by Nick on 10/28/24.
//

import SwiftUI

struct ErrorView: View {
    let error: RecipeError
    let retryAction: () -> Void
    
    var body: some View {
        VStack {
            Text("Error")
                .font(.title)
                .padding(.bottom)
            Text(error.localizedDescription)
                .multilineTextAlignment(.center)
                .padding()
            Button(action: retryAction) {
                Text("Try Again")
            }
            .padding(.top)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
