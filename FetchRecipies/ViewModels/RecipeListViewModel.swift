//
//  RecipeListViewModel.swift
//  FetchRecipies
//
//  Created by Nick on 10/28/24.
//

import SwiftUI
import Combine

class RecipeListViewModel: ObservableObject {
    @Published var allRecipes: [Recipe] = []
    @Published var recipes: [Recipe] = [] // Filtered recipes
    @Published var error: RecipeError?
    @Published var selectedCuisines: Set<String> = []
    @Published var cuisineTypes: [String] = []
    
#if DEBUG
    @Published var selectedDataSource: RecipeDataSource
#endif
    
    private var cancellables = Set<AnyCancellable>()
    private var dataSource: RecipeDataSource
    
    init(dataSource: RecipeDataSource = .allRecipes) {
        self.dataSource = dataSource
#if DEBUG
        self.selectedDataSource = dataSource
#endif
        fetchRecipes()
    }
    
    func fetchRecipes() {
        let url = dataSource.url
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response -> Data in
                if let httpResponse = response as? HTTPURLResponse,
                   !(200...299).contains(httpResponse.statusCode) {
                    throw RecipeError.networkError(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server error"]))
                }
                return data
            }
            .decode(type: [String: [Recipe]].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    if let decodingError = error as? DecodingError {
                        self?.error = .malformedData
                    } else if let recipeError = error as? RecipeError {
                        self?.error = recipeError
                    } else {
                        self?.error = .networkError(error)
                    }
                    self?.clearRecipes()
                }
            } receiveValue: { [weak self] data in
                if let recipes = data["recipes"], !recipes.isEmpty {
                    self?.allRecipes = recipes
                    self?.error = nil
                    self?.extractCuisineTypes()
                    self?.applyFilters()
                } else if data["recipes"] != nil {
                    self?.clearRecipes()
                    self?.error = .emptyData
                } else {
                    self?.clearRecipes()
                    self?.error = .malformedData
                }
            }
            .store(in: &cancellables)
    }
    
    func applySelectedDataSource() {
#if DEBUG
        self.dataSource = self.selectedDataSource
#endif
        fetchRecipes()
    }
    
    private func extractCuisineTypes() {
        let cuisines = allRecipes.map { $0.cuisine }
        self.cuisineTypes = Array(Set(cuisines)).sorted()
    }
    
    func toggleCuisine(_ cuisine: String) {
        if selectedCuisines.contains(cuisine) {
            selectedCuisines.remove(cuisine)
        } else {
            selectedCuisines.insert(cuisine)
        }
        applyFilters()
    }
    
    private func applyFilters() {
        if selectedCuisines.isEmpty {
            recipes = allRecipes
        } else {
            recipes = allRecipes.filter { selectedCuisines.contains($0.cuisine) }
        }
    }
    
    func clearRecipes() {
        allRecipes = []
        recipes = []
        cuisineTypes = []
        selectedCuisines = []
    }
}
