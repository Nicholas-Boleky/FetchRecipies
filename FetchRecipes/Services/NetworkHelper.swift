//
//  NetworkHelper.swift
//  FetchRecipies
//
//  Created by Nick on 10/30/24.
//

import Foundation
import Combine

class NetworkHelper {
    static func fetchData<T: Decodable>(from url: URL, responseType: T.Type) -> AnyPublisher<T, Error> {
        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalCacheData //Project requirements only cache images
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response -> Data in
                if let httpResponse = response as? HTTPURLResponse,
                   !(200...299).contains(httpResponse.statusCode) {
                    throw RecipeError.networkError(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server error"]))
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
