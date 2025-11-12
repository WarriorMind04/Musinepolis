//
//  SpotifyAPI.swift
//  Musinepolis
//
//  Created by José Miguel Guerrero Jiménez on 10/11/25.
//

import Foundation

final class SpotifyAPI {
    static let shared = SpotifyAPI()
    private init() {}
    
    private var accessToken: String?
    private var tokenExpiration: Date?
    
    // MARK: - Fetch Token from Backend
    /*func fetchAccessToken() async throws -> String {
        // Si ya tenemos token válido, lo devolvemos
        if let token = accessToken, let expiration = tokenExpiration, expiration > Date() {
            return token
        }
        
        // Endpoint de tu backend deployeado
        guard let url = URL(string: "https://back-mu-si-cnema-cihh8w4ld-jose-miguels-projects-4169b721.vercel.app/token") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        if let str = String(data: data, encoding: .utf8) {
            print("🎯 Respuesta backend:", str)
        }
        let response = try JSONDecoder().decode(BackendTokenResponse.self, from: data)
        
        self.accessToken = response.access_token
        self.tokenExpiration = Date().addingTimeInterval(TimeInterval(response.expires_in))
        return response.access_token
    }*/
    func fetchAccessToken() async throws -> String {
        // Return cached token if valid
        if let token = accessToken,
           let expiration = tokenExpiration,
           expiration > Date() {
            return token
        }

        guard let url = URL(string: "https://back-mu-si-cnema-cihh8w4ld-jose-miguels-projects-4169b721.vercel.app/token") else {
            throw URLError(.badURL)
        }

        // Create a custom URLRequest with a timeout
        var request = URLRequest(url: url)
        request.timeoutInterval = 10 // seconds

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("🔐 /token HTTP status:", httpResponse.statusCode)
            }
            if let str = String(data: data, encoding: .utf8) {
                print("🎯 Respuesta backend:", str)
            }
            
            let decoded = try JSONDecoder().decode(BackendTokenResponse.self, from: data)
            self.accessToken = decoded.access_token
            self.tokenExpiration = Date().addingTimeInterval(TimeInterval(decoded.expires_in))
            return decoded.access_token
        } catch {
            print("⚠️ Token fetch error:", error)
            throw error
        }
    }
    
    // MARK: - Search Tracks
    func searchTracks(query: String) async throws -> [Track] {
        let token = try await fetchAccessToken()
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://api.spotify.com/v1/search?q=\(encodedQuery)&type=track&limit=10") else {
            throw URLError(.badURL)
        }
        
        struct SearchResponse: Codable { let tracks: TrackItems }
        struct TrackItems: Codable { let items: [Track] }
        
        let result: SearchResponse = try await NetworkManager.shared.performRequest(url, token: token)
        return result.tracks.items
    }
    
    //Function in order to search for the albums rather tracks
    func searchAlbum(query: String) async throws -> [Album] {
        let token = try await fetchAccessToken()
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://api.spotify.com/v1/search?q=\(encodedQuery)&type=album&limit=10") else {
            throw URLError(.badURL)
        }
        
        struct SearchResponse: Codable { let albums: AlbumItems}
        struct AlbumItems: Codable { let items: [Album]}
        let result: SearchResponse = try await NetworkManager.shared.performRequest(url, token: token)
        return result.albums.items
    }
    
    //Function to see the song of a specific album
    func searchAlbumTracks(albumId: String) async throws -> [Track] {
        let token = try await fetchAccessToken()
        guard let url = URL(string: "https://api.spotify.com/v1/albums/\(albumId)/tracks?limit=50") else {
            throw URLError(.badURL)
        }
        
        struct AlbumTracksResponse: Codable { let items: [Track] }
        let result: AlbumTracksResponse = try await NetworkManager.shared.performRequest(url, token: token)
        return result.items
    }
    
    //Function to search the songs of specific playlists
    /*func searchPlaylistTracks(playlistId: String) async throws -> [Track] {
        let token = try await fetchAccessToken()
        guard let url = URL(string: "https://api.spotify.com/v1/playlists/\(playlistId)/tracks?limit=50") else {
            throw URLError(.badURL)
        }
        
        struct AlbumTracksResponse: Codable { let items: [Track] }
        let result: AlbumTracksResponse = try await NetworkManager.shared.performRequest(url, token: token)
        return result.items
    }*/
    func searchPlaylistTracks(playlistId: String) async throws -> [Track] {
        let token = try await fetchAccessToken()
        guard let url = URL(string: "https://api.spotify.com/v1/playlists/\(playlistId)/tracks?limit=50") else {
            throw URLError(.badURL)
        }
        
        // El JSON de Spotify tiene "items" que contienen un campo "track"
        struct PlaylistTracksResponse: Codable {
            let items: [PlaylistTrackItem]
        }

        struct PlaylistTrackItem: Codable {
            let track: Track
        }

        let result: PlaylistTracksResponse = try await NetworkManager.shared.performRequest(url, token: token)
        
        // Extraer el campo "track" de cada item
        return result.items.compactMap { $0.track }
        
    }

}

private struct BackendTokenResponse: Codable {
    let access_token: String
    let expires_in: Int
}
