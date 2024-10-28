//
//  Recipe.swift
//  FetchRecipies
//
//  Created by Nick on 10/28/24.
//

import Foundation

struct Recipe: Identifiable, Decodable {
    let id = UUID()  // Generate a unique identifier
    let cuisine: String
    let name: String
    let photoUrlLarge: URL
    let photoUrlSmall: URL
    let sourceUrl: URL
    let youtubeUrl: URL
    
    private enum CodingKeys: String, CodingKey {
        case cuisine, name
        case photoUrlLarge = "photo_url_large"
        case photoUrlSmall = "photo_url_small"
        case sourceUrl = "source_url"
        case youtubeUrl = "youtube_url"
    }
}
