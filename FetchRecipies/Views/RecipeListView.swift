//
//  RecipeListView.swift
//  FetchRecipies
//
//  Created by Nick on 10/28/24.
//

import SwiftUI
import YouTubePlayerKit
import SDWebImageSwiftUI

struct RecipeListView: View {
    @StateObject private var viewModel = RecipeListViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    #if DEBUG
                    // Picker for data source selection
                    Picker("Data Source", selection: $viewModel.selectedDataSource) {
                        ForEach(RecipeDataSource.allCases, id: \.self) { source in
                            Text(source.displayName).tag(source)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    #endif
                    
                    // Cuisine Filter View
                    CuisineFilterView(viewModel: viewModel)
                    
                    // Main content
                    Group {
                        if let error = viewModel.error {
                            ErrorView(error: error, retryAction: {
                                viewModel.applySelectedDataSource()
                            })
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else if viewModel.recipes.isEmpty {
                            EmptyStateView()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else {
                            LazyVStack {
                                //Using ForEach instead of List because it is more predictable with the expanding size I am using for the video player and full recipe link.
                                ForEach(viewModel.recipes, id: \.id) { recipe in
                                    RecipeRow(recipe: recipe)
                                        .padding(.horizontal)
                                        .padding(.bottom, 8)
                                }
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .navigationTitle("Recipes")
            .refreshable {
                viewModel.applySelectedDataSource()
            }
        }
    }
}


struct RecipeRow: View {
    let recipe: Recipe
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading) {
            // Header section
            HStack {
                WebImage(url: recipe.photoUrlSmall) { image in
                    image.resizable() // Control layout like SwiftUI.AsyncImage, you must use this modifier or the view will use the image bitmap size
                } placeholder: {
                    Rectangle().foregroundColor(.gray)
                }
                // Supports options and context, like `.delayPlaceholder` to show placeholder only when error
                .onSuccess { image, data, cacheType in
                    // Success
                    // Note: Data exist only when queried from disk cache or network. Use `.queryMemoryData` if you really need data
                }
                .indicator(.activity) // Activity Indicator
                .transition(.fade(duration: 0.5)) // Fade Transition with duration
                .scaledToFit()
                .frame(height: 50)
                .scaledToFit()
                
                VStack(alignment: .leading) {
                    Text(recipe.name)
                        .font(.headline)
                    Text(recipe.cuisine)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                
                Button(action: {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }) {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 20))
                        .foregroundColor(.gray)
                        .frame(width: 44, height: 44) // min tap size https://developer.apple.com/design/human-interface-guidelines/buttons
                        .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            // Expanded content
            if isExpanded {
                Divider()
                VStack(alignment: .leading, spacing: 8) {
                    // Source URL
                    if let sourceUrl = recipe.sourceUrl {
                        //Text("Source: \(sourceUrl.absoluteString)")
                        Link("Click here for full recipe", destination: sourceUrl)
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
                                Image("brokenYTLink")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 200)
                                    .cornerRadius(8)
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

