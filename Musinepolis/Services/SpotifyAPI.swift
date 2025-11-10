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
    func fetchAccessToken() async throws -> String {
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
}

private struct BackendTokenResponse: Codable {
    let access_token: String
    let expires_in: Int
}
