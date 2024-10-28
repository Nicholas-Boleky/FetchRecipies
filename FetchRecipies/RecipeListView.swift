//
//  RecipeListView.swift
//  FetchRecipies
//
//  Created by Nick on 10/28/24.
//

import SwiftUI

struct RecipeListView: View {
    @StateObject private var viewModel = RecipeViewModel()
    
    var body: some View {
        List(viewModel.recipes) { recipe in
            RecipeRow(recipe: recipe)
        }
        .listStyle(PlainListStyle())
    }
}

struct RecipeRow: View {
    let recipe: Recipe
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                AsyncImage(url: recipe.photoUrlSmall) { image in
                    image.resizable().scaledToFit().frame(width: 50, height: 50)
                } placeholder: {
                    ProgressView()
                }
                VStack(alignment: .leading) {
                    Text(recipe.name).font(.headline)
                    Text(recipe.cuisine).font(.subheadline).foregroundColor(.gray)
                }
                Spacer()
            }
            if isExpanded {
                Divider()
                VStack(alignment: .leading, spacing: 8) {
                    Text("Source: \(recipe.sourceUrl.absoluteString)")
                        .font(.footnote)
                        .foregroundColor(.blue)
                    Text("YouTube: \(recipe.youtubeUrl.absoluteString)")
                        .font(.footnote)
                        .foregroundColor(.blue)
                }
                .padding(.top, 4)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 2)
        .onTapGesture {
            withAnimation {
                isExpanded.toggle()
            }
        }
    }
}
