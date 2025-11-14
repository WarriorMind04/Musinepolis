//
//  SongSearchView.swift
//  Musinepolis
//
//  Created by José Miguel Guerrero Jiménez on 14/11/25.
//

import SwiftUI

struct SongSearchView: View {

    @StateObject private var musicService = MusicService()
    @State private var searchText = ""

    var body: some View {
        NavigationView {
            VStack {
                
                // Search bar
                TextField("Search songs...", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button("Search") {
                    Task {
                        await musicService.searchSongs(query: searchText)
                    }
                }
                .buttonStyle(.borderedProminent)

                Divider()

                // Song results
                List(musicService.songs, id: \.id) { song in
                    SongRowView(song: song) {
                        if let url = musicService.previewURL(for: song) {
                            PreviewPlayer.shared.playPreview(url: url)
                        }
                    }
                }
            }
            .navigationTitle("Music Search")
        }
    }
}

#Preview {
    SongSearchView()
}
