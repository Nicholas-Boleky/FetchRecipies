//
//  RecipeError.swift
//  FetchRecipies
//
//  Created by Nick on 10/28/24.
//

import Foundation

enum RecipeError: Error, LocalizedError, Identifiable {
    case malformedData
    case emptyData
    case networkError(Error)

    var id: String { localizedDescription }

    var errorDescription: String? {
        switch self {
        case .malformedData:
            return "Failed to load recipes due to malformed data."
        case .emptyData:
            return "No recipes are available at the moment."
        case .networkError(let error):
            return error.localizedDescription
        }
    }
}
