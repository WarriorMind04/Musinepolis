//
//  SongRowView.swift
//  Musinepolis
//
//  Created by José Miguel Guerrero Jiménez on 14/11/25.
//

import SwiftUI
import MusicKit

struct SongRowView: View {
    let song: Song
    let onPlayPreview: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(song.title)
                    .font(.headline)

                // artistName is non-optional in MusicKit.Song
                if !song.artistName.isEmpty {
                    Text(song.artistName)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            Button(action: onPlayPreview) {
                Image(systemName: "play.circle.fill")
                    .font(.title2)
                    .foregroundColor(.red)
            }
        }
        .padding(.vertical, 6)
    }
}

#Preview {
    // MusicKit.Song isn't trivially initializable; show a placeholder to keep preview compiling.
    VStack(alignment: .leading, spacing: 12) {
        Text("SongRowView Preview Placeholder")
            .font(.headline)
        Text("Provide a stub Song if available to preview the real row.")
            .font(.subheadline)
            .foregroundColor(.secondary)
    }
    .padding()
}
