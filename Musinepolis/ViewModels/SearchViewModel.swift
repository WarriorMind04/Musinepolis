//
//  SearchViewModel.swift
//  Musinepolis
//
//  Created by José Miguel Guerrero Jiménez on 10/11/25.
//

import SwiftUI
import AVFoundation
internal import Combine

@MainActor
class TracksViewModel: ObservableObject {
    @Published var tracks: [Track] = []
    @Published var isLoading: Bool = false
    
    private var player: AVPlayer?
    
    func fetchTracks(query: String) async{
        isLoading = true
        defer { isLoading = false }
        do{
            let results = try await SpotifyAPI.shared.searchTracks(query: query)
            print("🎵 Tracks encontrados:", results.count)
            self.tracks = results
        } catch{
            print("Error buscando tracks:", error)
            self.tracks = []
        }
    }
    func playPreview(_ urlString: String?) {
            guard let urlString = urlString, let url = URL(string: urlString) else { return }
            player = AVPlayer(url: url)
            player?.play()
        }
        
        func stopPreview() {
            player?.pause()
            player = nil
        }
    
}

    
            
