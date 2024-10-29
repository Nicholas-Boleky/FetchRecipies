//
//  RecipeDataSource.swift
//  FetchRecipies
//
//  Created by Nick on 10/28/24.
//

import Foundation

enum RecipeDataSource: String, CaseIterable {
    case allRecipes = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
    case malformedData = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"
    case emptyData = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"
    
    var url: URL {
        return URL(string: self.rawValue)!
    }
    
    var displayName: String {
        switch self {
        case .allRecipes:
            return "All Recipes"
        case .malformedData:
            return "Malformed Data"
        case .emptyData:
            return "Empty Data"
        }
    }
}
