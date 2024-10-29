//
//  CuisineFilterView.swift
//  FetchRecipies
//
//  Created by Nick on 10/28/24.
//

import SwiftUI

struct CuisineFilterView: View {
    @ObservedObject var viewModel: RecipeListViewModel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(viewModel.cuisineTypes, id: \.self) { cuisine in
                    Button(action: {
                        viewModel.toggleCuisine(cuisine)
                    }) {
                        Text(cuisine)
                            .font(.subheadline)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(viewModel.selectedCuisines.contains(cuisine) ? Color.blue : Color.gray.opacity(0.2))
                            .foregroundColor(viewModel.selectedCuisines.contains(cuisine) ? .white : .primary)
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.blue, lineWidth: viewModel.selectedCuisines.contains(cuisine) ? 0 : 1)
                            )
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
    }
}
