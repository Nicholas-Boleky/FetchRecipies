//
//  RecipeListViewModel.swift
//  FetchRecipies
//
//  Created by Nick on 10/28/24.
//

import SwiftUI
import Combine

class RecipeViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchRecipes()
    }
    
    func fetchRecipes() {
        // Temporary mock data
        let mockData = Recipe(
            backendID: "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
            cuisine: "Malaysian",
            name: "Apam Balik",
            photoUrlLarge: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg")!,
            photoUrlSmall: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg")!,
            sourceUrl: URL(string: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ")!,
            youtubeUrl: URL(string: "https://www.youtube.com/watch?v=6R8ffRRJcrg")!
        )
        self.recipes = [mockData]
    }
}
