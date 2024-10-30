//
//  YouTubePlayerWrapper.swift
//  FetchRecipies
//
//  Created by Nick on 10/30/24.
//

import SwiftUI
import YouTubePlayerKit

struct YouTubePlayerViewWrapper: View {
    let videoID: String?
    
    var body: some View {
        if let videoID = videoID {
            let youtubePlayer = YouTubePlayer(source: .video(id: videoID))
            
            YouTubePlayerView(youtubePlayer) { state in
                switch state {
                case .idle:
                    ProgressView()
                case .ready:
                    EmptyView()
                case .error(_):
                    Image("brokenYTLink")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .cornerRadius(8)
                }
            }
            .aspectRatio(16 / 9, contentMode: .fit)
            .frame(maxWidth: .infinity)
            .frame(height: 200)
            .cornerRadius(8)
        } else {
            Image("brokenYTLink")
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .cornerRadius(8)
                .frame(maxWidth: .infinity)
        }
    }
}
