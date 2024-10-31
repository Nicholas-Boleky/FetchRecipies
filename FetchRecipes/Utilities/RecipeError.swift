//
//  RecipeError.swift
//  FetchRecipies
//
//  Created by Nick on 10/28/24.
//

import Foundation

enum RecipeError: Error, LocalizedError, Identifiable, Equatable {
    case malformedData
    case emptyData
    case networkError(Error)

    var id: String { localizedDescription }

    var errorDescription: String? {
        switch self {
        case .malformedData:
            return "Failed to load recipes, something doesn't look quite right, please check back later."
        case .emptyData:
            return "No recipes are available at the moment."
        case .networkError(let error):
            return error.localizedDescription
        }
    }
    
    // Conformance to Equatable was required for testMalformedDataHandleing unit test
    static func == (lhs: RecipeError, rhs: RecipeError) -> Bool {
        switch (lhs, rhs) {
        case (.malformedData, .malformedData),
             (.emptyData, .emptyData):
            return true
        case (.networkError(let lhsError), .networkError(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}
