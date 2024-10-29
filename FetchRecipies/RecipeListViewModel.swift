//
//  RecipeListViewModel.swift
//  FetchRecipies
//
//  Created by Nick on 10/28/24.
//

import SwiftUI
import Combine

import SwiftUI
import Combine

class RecipeListViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var error: RecipeError?
    
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
                    self?.recipes = []
                }
            } receiveValue: { [weak self] data in
                if let recipes = data["recipes"], !recipes.isEmpty {
                    self?.recipes = recipes
                    self?.error = nil
                } else if data["recipes"] != nil {
                    self?.recipes = []
                    self?.error = .emptyData
                } else {
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
}
