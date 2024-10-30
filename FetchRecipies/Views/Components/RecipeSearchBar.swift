//
//  RecipeSearchBar.swift
//  FetchRecipies
//
//  Created by Nick on 10/29/24.
//

import Foundation

import SwiftUI

struct RecipeSearchBar: View {
    @Binding var searchText: String
    var placeholder: String = "Search..."

    var body: some View {
        HStack {
            TextField(placeholder, text: $searchText)
                .padding(8)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        
                        if !searchText.isEmpty {
                            Button(action: {
                                searchText = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .padding(.horizontal, 10)
        }
        .padding(.top, 10)
    }
}

