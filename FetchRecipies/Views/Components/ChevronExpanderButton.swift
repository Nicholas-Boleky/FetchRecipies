//
//  ChevronExpanderButton.swift
//  FetchRecipies
//
//  Created by Nick on 10/30/24.
//

import SwiftUI

struct ChevronButton: View {
    @Binding var isExpanded: Bool
    
    var body: some View {
        Button(action: {
            withAnimation {
                isExpanded.toggle()
            }
        }) {
            Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                .font(.system(size: 20))
                .foregroundColor(.gray)
                .frame(width: 44, height: 44)
                .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}
