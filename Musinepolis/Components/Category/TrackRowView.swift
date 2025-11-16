//
//  TrackRowView.swift
//  Musinepolis
//
//  Created by José Miguel Guerrero Jiménez on 16/11/25.
//

import SwiftUI
import MusicKit

struct TrackRowView: View {
    let track: AppleMusicTrack
    let onPlay: () -> Void
    
    var body: some View {
        HStack(spacing: 10) {
            artwork
            
            VStack(alignment: .leading, spacing: 4) {
                Text(track.title)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(track.artistName)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            playButton
        }
        .padding(.vertical, 4)
    }
    
    @ViewBuilder
    private var artwork: some View {
        if let artwork = track.artwork {
            ArtworkImage(artwork, width: 60, height: 60)
                .cornerRadius(8)
        } else {
            placeholderArtwork
        }
    }
    
    private var placeholderArtwork: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.gray.opacity(0.3))
            .frame(width: 60, height: 60)
            .overlay(
                Image(systemName: "music.note")
                    .foregroundColor(.gray)
            )
    }
    
    private var playButton: some View {
        Group {
            if track.previewAssets?.first != nil {
                Button(action: onPlay) {
                    Image(systemName: "play.circle.fill")
                        .font(.title2)
                        .foregroundColor(.pink)
                }
            } else {
                Image(systemName: "play.circle")
                    .font(.title2)
                    .foregroundColor(.gray.opacity(0.5))
            }
        }
    }
}
