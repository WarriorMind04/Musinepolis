//
//  SearchViewModel.swift
//  Musinepolis
//
//  Created by José Miguel Guerrero Jiménez on 10/11/25.
//

import SwiftUI
import AVFoundation
import Combine

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
    
    func fetchTracksAlbum(for albumId: String) async{
        isLoading = true
        defer { isLoading = false }
        do{
            let results = try await SpotifyAPI.shared.searchAlbumTracks(albumId:  albumId)
            print("🎵 Tracks encontrados:", results.count)
            self.tracks = results
        } catch{
            print("Error buscando tracks:", error)
            self.tracks = []
        }
    }
    
    func fetchTracksPlaylist(for playlistId: String) async{
        isLoading = true
        defer { isLoading = false }
        do{
            let results = try await SpotifyAPI.shared.searchPlaylistTracks(playlistId: playlistId)
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
    func loadDefaultTracks(for movie: String) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            // Usamos el nombre de la película como query predeterminado
            let results = try await SpotifyAPI.shared.searchTracks(query: movie)
            self.tracks = results
        } catch {
            print("Error cargando tracks predeterminados:", error)
            self.tracks = []
        }
    }
    
}

