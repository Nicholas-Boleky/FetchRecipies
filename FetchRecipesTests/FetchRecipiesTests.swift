//
//  FetchRecipiesTests.swift
//  FetchRecipiesTests
//
//  Created by Nick on 10/27/24.
//

import XCTest
@testable import FetchRecipies

final class RecipeListViewModelTests: XCTestCase {
    
    var viewModel: RecipeListViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = RecipeListViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testSearchQueryFiltering() {
        // Given: these are the recipe array
        let recipes = [
            Recipe(backendID: "", cuisine: "American", name: "Banana Pancakes", photoUrlLarge: URL(fileURLWithPath: ""), photoUrlSmall: URL(fileURLWithPath: ""), sourceUrl: URL(fileURLWithPath: ""), youtubeUrl: URL(fileURLWithPath: "")),
            Recipe(backendID: "", cuisine: "British", name: "Apple & Blackberry Crumble", photoUrlLarge: URL(fileURLWithPath: ""), photoUrlSmall: URL(fileURLWithPath: ""), sourceUrl: URL(fileURLWithPath: ""), youtubeUrl: URL(fileURLWithPath: "")),
            Recipe(backendID: "", cuisine: "Canadian", name: "Beaver Tails", photoUrlLarge: URL(fileURLWithPath: ""), photoUrlSmall: URL(fileURLWithPath: ""), sourceUrl: URL(fileURLWithPath: ""), youtubeUrl: URL(fileURLWithPath: ""))
        ]
        viewModel.allRecipes = recipes
        
        // When: User enters search query
        viewModel.searchQuery = "Beaver"
        viewModel.applyFilters()
        // Then: filtered recipes show matching recipe
        XCTAssertEqual(viewModel.recipes.count, 1)
        XCTAssertEqual(viewModel.recipes.first?.name, "Beaver Tails")
    }
    
    func testCuisineFilteringIncludesSelected() {
        // Given: these are the recipe array
        let recipes = [
            Recipe(backendID: "", cuisine: "American", name: "Banana Pancakes", photoUrlLarge: URL(fileURLWithPath: ""), photoUrlSmall: URL(fileURLWithPath: ""), sourceUrl: URL(fileURLWithPath: ""), youtubeUrl: URL(fileURLWithPath: "")),
            Recipe(backendID: "", cuisine: "British", name: "Apple & Blackberry Crumble", photoUrlLarge: URL(fileURLWithPath: ""), photoUrlSmall: URL(fileURLWithPath: ""), sourceUrl: URL(fileURLWithPath: ""), youtubeUrl: URL(fileURLWithPath: "")),
            Recipe(backendID: "", cuisine: "Canadian", name: "Beaver Tails", photoUrlLarge: URL(fileURLWithPath: ""), photoUrlSmall: URL(fileURLWithPath: ""), sourceUrl: URL(fileURLWithPath: ""), youtubeUrl: URL(fileURLWithPath: ""))
        ]
        viewModel.allRecipes = recipes
        
        // When: User selects cusilne filters
        viewModel.selectedCuisines = ["American", "British"]
        viewModel.applyFilters()
        
        // Then: Matching recipes are found
        XCTAssertEqual(viewModel.recipes.count, 2)
        XCTAssertTrue(viewModel.recipes.contains { $0.name == "Banana Pancakes" })
        XCTAssertTrue(viewModel.recipes.contains { $0.name == "Apple & Blackberry Crumble" })
    }
    
    func testCuisineFilteringExcludesUnselected() {
        // Given: these are the recipe array
        let recipes = [
            Recipe(backendID: "", cuisine: "American", name: "Banana Pancakes", photoUrlLarge: URL(fileURLWithPath: ""), photoUrlSmall: URL(fileURLWithPath: ""), sourceUrl: URL(fileURLWithPath: ""), youtubeUrl: URL(fileURLWithPath: "")),
            Recipe(backendID: "", cuisine: "British", name: "Apple & Blackberry Crumble", photoUrlLarge: URL(fileURLWithPath: ""), photoUrlSmall: URL(fileURLWithPath: ""), sourceUrl: URL(fileURLWithPath: ""), youtubeUrl: URL(fileURLWithPath: "")),
            Recipe(backendID: "", cuisine: "Canadian", name: "Beaver Tails", photoUrlLarge: URL(fileURLWithPath: ""), photoUrlSmall: URL(fileURLWithPath: ""), sourceUrl: URL(fileURLWithPath: ""), youtubeUrl: URL(fileURLWithPath: ""))
        ]
        viewModel.allRecipes = recipes
        
        // When: User toggles filter for cuisine
        viewModel.toggleCuisine("American")
        viewModel.applyFilters()
        
        // Then: Only the "American" recipes should be in the filtered list
        XCTAssertEqual(viewModel.recipes.count, 1)
        XCTAssertEqual(viewModel.recipes.first?.cuisine, "American")
        XCTAssertEqual(viewModel.recipes.first?.name, "Banana Pancakes")
        
        // Verifes that other cuisines are not included in filtered recipes
        XCTAssertFalse(viewModel.recipes.contains { $0.cuisine == "British" })
        XCTAssertFalse(viewModel.recipes.contains { $0.cuisine == "Canadian" })
    }
}
