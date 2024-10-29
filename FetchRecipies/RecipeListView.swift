//
//  RecipeListView.swift
//  FetchRecipies
//
//  Created by Nick on 10/28/24.
//

import SwiftUI
import YouTubePlayerKit

struct RecipeListView: View {
    @StateObject private var viewModel = RecipeListViewModel()
    
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
            // Existing header code
            HStack {
                AsyncImage(url: recipe.photoUrlSmall) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                } placeholder: {
                    ProgressView()
                        .frame(width: 50, height: 50)
                }
                VStack(alignment: .leading) {
                    Text(recipe.name)
                        .font(.headline)
                    Text(recipe.cuisine)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            .onTapGesture {
                withAnimation {
                    isExpanded.toggle()
                }
            }

            // Expanded content
            if isExpanded {
                Divider()
                VStack(alignment: .leading, spacing: 8) {
                    // Source URL
                    if let sourceUrl = recipe.sourceUrl {
                        //Text("Source: \(sourceUrl.absoluteString)")
                        Link("Click here for full  recipe", destination: sourceUrl)
                            .font(.footnote)
                    }

                    // YouTube Video
                    if let videoID = recipe.youtubeVideoID {
                        // Create YouTubePlayer instance
                        let youtubePlayer = YouTubePlayer(source: .video(id: videoID))

                        // Display the player
                        YouTubePlayerView(youtubePlayer) { state in
                            switch state {
                            case .idle:
                                ProgressView()
                            case .ready:
                                EmptyView()
                            case .error(_):
                                //The player already displays an error here if the video is unavailable so another EmptyView is used.
                                EmptyView()
                            }
                        }
                        .frame(height: 200) // Adjust height as needed
                        .cornerRadius(8)
                    } else {
                        Text("No video available.")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.top, 4)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(radius: 2)
    }
}

