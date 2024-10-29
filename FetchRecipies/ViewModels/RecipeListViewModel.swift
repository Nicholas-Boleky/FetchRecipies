//
//  RecipeListViewModel.swift
//  FetchRecipies
//
//  Created by Nick on 10/28/24.
//

import SwiftUI
import Combine

class RecipeListViewModel: ObservableObject {
    @Published var allRecipes: [Recipe] = [] // fetched recipes
    @Published var recipes: [Recipe] = [] // Filtered recipes
    @Published var error: RecipeError?
    @Published var selectedCuisines: Set<String> = []
    @Published var cuisineTypes: [String] = []
    
    private var cancellables = Set<AnyCancellable>()
    private var dataSource: RecipeDataSource
    
    init(dataSource: RecipeDataSource = .allRecipes) {
        self.dataSource = dataSource
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
                    self?.allRecipes = []
                    self?.recipes = []
                }
            } receiveValue: { [weak self] data in
                if let recipes = data["recipes"], !recipes.isEmpty {
                    self?.allRecipes = recipes
                    self?.error = nil
                    self?.extractCuisineTypes()
                    self?.applyFilters()
                } else if data["recipes"] != nil {
                    self?.allRecipes = []
                    self?.recipes = []
                    self?.error = .emptyData
                } else {
                    self?.allRecipes = []
                    self?.recipes = []
                    self?.error = .malformedData
                }
            }
            .store(in: &cancellables)
    }
    
    func updateDataSource(to newDataSource: RecipeDataSource) {
        self.dataSource = newDataSource
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
}

