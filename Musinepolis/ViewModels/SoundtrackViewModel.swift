//
//  SoundtrackViewModel.swift
//  Musinepolis
//
//  Created by José Miguel Guerrero Jiménez on 16/11/25.
//

import Foundation
import MusicKit
import Combine

/// ViewModel unificado que maneja tanto Albums como Playlists
class SoundtrackViewModel: ObservableObject {
    
    @Published var tracks: [AppleMusicTrack] = []
    @Published var songs: [Song] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let musicService = MusicService()
    
    /// Busca soundtrack según el tipo de media
    func fetchSoundtrack(for item: MediaItem) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        guard let soundtrackName = item.soundtrackName else {
            errorMessage = "No soundtrack name available"
            return
        }
        
        switch item.type {
        case .series:
            // Series busca en Playlists
            await fetchFromPlaylist(name: soundtrackName)
            
        case .movie, .game:
            // Movies y Games buscan en Albums
            await fetchFromAlbum(name: soundtrackName)
        }
    }
    
    // MARK: - Private Methods
    
    private func fetchFromAlbum(name: String) async {
        print("🎬 Buscando álbum: \(name)")
        
        let foundTracks = await musicService.searchAndLoadAlbum(query: name)
        
        await MainActor.run {
            self.tracks = foundTracks
            self.songs = [] // Limpia songs cuando usa tracks
            
            if foundTracks.isEmpty {
                errorMessage = "No se encontraron canciones en el álbum"
            }
        }
    }
    
    private func fetchFromPlaylist(name: String) async {
        print("📺 Buscando playlist: \(name)")
        
        var foundSongs = await musicService.searchAndLoadPlaylistSong(query: name)
        
        // Fallback: intentar con "OST" agregado
        if foundSongs.isEmpty {
            print("⚠️ Intentando con '\(name) OST'...")
            foundSongs = await musicService.searchAndLoadPlaylistSong(query: "\(name) OST")
        }
        
        await MainActor.run {
            self.songs = foundSongs
            self.tracks = [] // Limpia tracks cuando usa songs
            
            if foundSongs.isEmpty {
                errorMessage = "No se encontraron canciones en la playlist"
            }
        }
    }
    
    // MARK: - Preview Playback
    
    func playPreview(track: AppleMusicTrack) {
        guard let previewURL = musicService.previewURL(for: track) else {
            print("⚠️ No hay preview disponible para este track")
            return
        }
        PreviewPlayer.shared.playPreview(url: previewURL)
    }
    
    func playPreview(song: Song) {
        guard let previewURL = musicService.previewURL(for: song) else {
            print("⚠️ No hay preview disponible para esta canción")
            return
        }
        PreviewPlayer.shared.playPreview(url: previewURL)
    }
    
    func stopPreview() {
        PreviewPlayer.shared.stop()
    }
    
    // MARK: - Helper
    
    var hasContent: Bool {
        !tracks.isEmpty || !songs.isEmpty
    }
}
