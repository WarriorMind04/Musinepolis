//
//  PlaylistSongsViewModel.swift
//  Musinepolis
//
//  Created by José Miguel Guerrero Jiménez on 15/11/25.
//

import Foundation
import MusicKit
import Combine

class PlaylistSongsViewModel: ObservableObject {
    @Published var songs: [Song] = []
    @Published var isLoading = false
    
    private let musicService = MusicService()
    
    func fetchSongs(playlistName: String) async {
        isLoading = true
        defer { isLoading = false }
        
        print("🔎 Buscando soundtrack: \(playlistName)")
        
        // Primero intentar playlist
        var foundSongs = await musicService.searchAndLoadPlaylistSong(query: playlistName)
        
        // Si no encuentra nada, buscar directamente canciones
        if foundSongs.isEmpty {
            print("⚠️ Playlist vacía, buscando canciones con término modificado...")
            // Intentar con "OST" o "soundtrack" agregado
            foundSongs = await musicService.searchAndLoadPlaylistSong(query: "\(playlistName) OST")
        }
        
        self.songs = foundSongs
        
        if foundSongs.isEmpty {
            print("❌ No se encontraron canciones para: \(playlistName)")
        } else {
            print("✅ Total canciones cargadas: \(foundSongs.count)")
        }
    }
    
    func playPreview(_ song: Song) {
        guard let previewURL = musicService.previewURL(for: song) else {
            print("No hay preview disponible")
            return
        }
        PreviewPlayer.shared.playPreview(url: previewURL)
    }
    
    func stopPreview() {
        PreviewPlayer.shared.stop()
    }
}
