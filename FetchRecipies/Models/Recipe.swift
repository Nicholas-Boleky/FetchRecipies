//
//  Recipe.swift
//  FetchRecipies
//
//  Created by Nick on 10/28/24.
//

import Foundation

struct Recipe: Identifiable, Decodable, Equatable {
    // we will still generate a unique ID here on the mobile side mostly because I am not sure how the UUIDs on the backend are created/handled and if someone enters a duplicate by error it could cause issues for us on mobile.
    let id = UUID()  // Generate a unique identifier
    let backendID: String
    let cuisine: String
    let name: String
    let photoUrlLarge: URL
    let photoUrlSmall: URL
    let sourceUrl: URL? //some recipes do not have a source_url
    let youtubeUrl: URL? //some recipes do not have a youtube_url
    
    private enum CodingKeys: String, CodingKey {
        case cuisine, name
        case backendID = "uuid"
        case photoUrlLarge = "photo_url_large"
        case photoUrlSmall = "photo_url_small"
        case sourceUrl = "source_url"
        case youtubeUrl = "youtube_url"
    }
}

extension Recipe {
    var youtubeVideoID: String? {
        guard let youtubeUrl = youtubeUrl else { return nil }
        let urlString = youtubeUrl.absoluteString
        
        // Handle standard YouTube URLs
        if let urlComponents = URLComponents(string: urlString),
           urlComponents.host?.contains("youtube.com") == true {
            return urlComponents.queryItems?.first(where: { $0.name == "v" })?.value
        }
        
        // Handle shortened YouTube URLs (youtu.be)
        if youtubeUrl.host == "youtu.be" {
            return youtubeUrl.lastPathComponent
        }
        
        return nil
    }
}
