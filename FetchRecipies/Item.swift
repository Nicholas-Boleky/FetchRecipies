//
//  Item.swift
//  FetchRecipies
//
//  Created by Nick on 10/27/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
