//
//  RecipeListViewModel.swift
//  FetchRecipies
//
//  Created by Nick on 10/28/24.
//

import SwiftUI
import Combine
import SDWebImage

class RecipeListViewModel: ObservableObject {
    @Published var allRecipes: [Recipe] = [] //All recipes regardless of filter selected
    @Published var recipes: [Recipe] = [] // Filtered recipes
    @Published var error: RecipeError?
    @Published var isLoading: Bool = false
    @Published var selectedCuisines: Set<String> = []
    @Published var cuisineTypes: [String] = []
    @Published var searchQuery: String = ""
    @Published var showNoRecipeAlert: Bool = false
    
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
        setupSearchListener()
    }
    
    func fetchRecipes() {
        isLoading = true
        error = nil // Reset error state on new fetch
        
        NetworkHelper.fetchData(from: dataSource.url, responseType: [String: [Recipe]].self)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.handleError(error)
                    self?.clearRecipes()
                }
            } receiveValue: { [weak self] data in
                self?.isLoading = false
                if let recipes = data["recipes"], !recipes.isEmpty {
                    self?.allRecipes = recipes
                    self?.error = nil
                    self?.extractCuisineTypes()
                    self?.applyFilters()
                    
#if DEBUG
                    let imageKeys = self?.recipes.map { $0.photoUrlSmall.absoluteString }
                    self?.printCacheContents(forKeys: imageKeys ?? [])
#endif
                } else {
                    self?.handleEmptyOrMalformedData(data: data)
                }
            }
            .store(in: &cancellables)
    }
    
    private func handleError(_ error: Error) {
        if let _ = error as? DecodingError {
            self.error = .malformedData
        } else if let recipeError = error as? RecipeError {
            self.error = recipeError
        } else {
            self.error = .networkError(error)
        }
    }
    
    private func handleEmptyOrMalformedData(data: [String: [Recipe]]) {
        if data["recipes"] != nil {
            clearRecipes()
            error = .emptyData
        } else {
            clearRecipes()
            error = .malformedData
        }
    }
    
    private func setupSearchListener() {
        $searchQuery
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.applyFilters()
            }
            .store(in: &cancellables)
    }
    
    func applySelectedDataSource() {
        #if DEBUG
        self.dataSource = self.selectedDataSource //This only exists in debug
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
    
    func applyFilters() {
        var filteredRecipes = allRecipes
        
        // If selected cuisines is not empty (someone has triggered filter tiles) then filter by those cuisines
        if !selectedCuisines.isEmpty {
            filteredRecipes = filteredRecipes.filter { selectedCuisines.contains($0.cuisine) }
        }
        
        // If search bar is not empty (someone has typed in the search bar) then filter by text in search query
        if !searchQuery.isEmpty {
            filteredRecipes = filteredRecipes.filter { $0.name.lowercased().contains(searchQuery.lowercased()) }
        }
        
        recipes = filteredRecipes
    }
    
    func clearRecipes() {
        allRecipes = []
        recipes = []
        cuisineTypes = []
        selectedCuisines = []
    }
    
    func showNoFullRecipeAlert() {
        showNoRecipeAlert = true
    }
    
    //only called in debug
#if DEBUG
    func printCacheContents(forKeys keys: [String]) {
        let cache = SDImageCache.shared
        
        print("Checking cache status for known image keys:")
        for key in keys {
            let isCached = cache.diskImageDataExists(withKey: key)
            print("Key: \(key) - Cached: \(isCached)")
        }
    }
#endif
}
