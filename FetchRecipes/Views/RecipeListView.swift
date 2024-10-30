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
        NavigationStack {
            ScrollView {
                VStack {
#if DEBUG
                    RecipeDataSourcePicker(selectedDataSource: $viewModel.selectedDataSource) //Data source picker only for dev testing
#endif
                    RecipeSearchBar(searchText: $viewModel.searchQuery, placeholder: "Search Recipes...")
                    
                    if !viewModel.isLoading {
                        CuisineFilterView(viewModel: viewModel)
                        
                        RecipeContentView(viewModel: viewModel)
                    } else {
                        ProgressView("Loading Recipes...")
                            .padding()
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

struct RecipeDataSourcePicker: View {
    @Binding var selectedDataSource: RecipeDataSource
    
    var body: some View {
        
        Picker("Data Source", selection: $selectedDataSource) {
            ForEach(RecipeDataSource.allCases, id: \.self) { source in
                Text(source.displayName).tag(source)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
        
    }
}

struct CuisineFilterView: View {
    @ObservedObject var viewModel: RecipeListViewModel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(viewModel.cuisineTypes, id: \.self) { cuisine in
                    Button(action: {
                        viewModel.toggleCuisine(cuisine)
                    }) {
                        Text(cuisine)
                            .font(.subheadline)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(viewModel.selectedCuisines.contains(cuisine) ? Color.blue : Color.gray.opacity(0.2))
                            .foregroundColor(viewModel.selectedCuisines.contains(cuisine) ? .white : .primary)
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.blue, lineWidth: viewModel.selectedCuisines.contains(cuisine) ? 0 : 1)
                            )
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
    }
}

struct RecipeContentView: View {
    @ObservedObject var viewModel: RecipeListViewModel
    
    var body: some View {
        Group {
            if let error = viewModel.error {
                if error == .malformedData || error == .networkError(error) {
                    ErrorView(error: error, retryAction: {
                        //typically I would just refresh data here but given the only way data will change is if the segmented controlelr selects the data set that isnt malformed, I am checking to refresh the selected data source we are pulling from.
                        viewModel.applySelectedDataSource()
                        
                    })
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if error == .emptyData {
                    EmptyStateView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            } else {
                RecipeList(recipes: viewModel.recipes, viewModel: viewModel)
            }
        }
    }
}

struct RecipeList: View {
    let recipes: [Recipe]
    @ObservedObject var viewModel: RecipeListViewModel
    
    var body: some View {
        LazyVStack {
            ForEach(recipes, id: \.id) { recipe in
                RecipeRow(recipe: recipe, viewModel: viewModel)
                    .padding(.horizontal)
                    .padding(.bottom, 8)
            }
        }
    }
}

struct RecipeRow: View {
    let recipe: Recipe
    @ObservedObject var viewModel: RecipeListViewModel
    @State private var isExpanded = false
    @State private var showShareSheet = false
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                RecipeHeader(recipe: recipe)
                ChevronButton(isExpanded: $isExpanded)
            }
            if isExpanded {
                Divider()
                VStack(alignment: .leading, spacing: 8) {
                    YouTubePlayerViewWrapper(videoID: recipe.youtubeVideoID)
                    
                    UrlShareButton(
                        sourceUrl: recipe.sourceUrl,
                        showShareSheet: $showShareSheet,
                        showAlert: {
                            viewModel.showNoFullRecipeAlert()
                        }
                    )
                }
                .padding(.top, 4)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(radius: 2)
        .onAppear {
            if horizontalSizeClass == .regular {
                isExpanded = true
            }
        }
        .alert(isPresented: $viewModel.showNoRecipeAlert, content: {
            Alert(title: Text("Error"), message: Text("Link to full recipe for this item wasn't found"), dismissButton: .default(Text("Okay")))
        })
    }
}

struct RecipeHeader: View {
    let recipe: Recipe
    
    var body: some View {
        HStack {
            WebImage(url: recipe.photoUrlSmall) { image in
                image.resizable()
            } placeholder: {
                Rectangle().foregroundColor(.gray)
            }
            .indicator(.activity)
            .transition(.fade(duration: 0.5))
            .scaledToFit()
            .frame(height: 50)
            
            VStack(alignment: .leading) {
                Text(recipe.name)
                    .font(.headline)
                Text(recipe.cuisine)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
    }
}




