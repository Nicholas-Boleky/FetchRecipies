//
//  UrlShareButton.swift
//  FetchRecipies
//
//  Created by Nick on 10/30/24.
//

import SwiftUI

struct UrlShareButton: View {
    let sourceUrl: URL?
    @Binding var showShareSheet: Bool
    let showAlert: () -> Void
    
    var body: some View {
        if let sourceUrl = sourceUrl {
            Button(action: {
                showShareSheet = true
            }) {
                UrlShareButtonVisualComponents()
            }
            .buttonStyle(PlainButtonStyle())
            .frame(maxWidth: .infinity)
            .sheet(isPresented: $showShareSheet) {
                ActivityView(activityItems: [sourceUrl])
            }
        } else {
            Button(action: {
                showAlert()
            }) {
                UrlShareButtonVisualComponents()
            }
            .buttonStyle(PlainButtonStyle())
            .frame(maxWidth: .infinity)
        }
    }
}

struct UrlShareButtonVisualComponents: View {
    var body: some View {
        HStack {
            Image(systemName: "square.and.arrow.up")
            Text("Share Full Recipe Page")
        }
        .font(.footnote)
        .foregroundColor(.blue)
        .padding(8)
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}
