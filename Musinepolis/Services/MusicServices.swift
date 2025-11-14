//
//  MusicServices.swift
//  Musinepolis
//
//  Created by José Miguel Guerrero Jiménez on 14/11/25.
//

import Foundation
import Combine
import MusicKit

@MainActor
class MusicService: ObservableObject {

    @Published var songs: [Song] = []
    @Published var authorizationStatus: MusicAuthorization.Status = .notDetermined
    
    init() {
        Task {
            await requestAuthorization()
        }
    }

    func requestAuthorization() async {
        authorizationStatus = await MusicAuthorization.request()
    }

    func searchSongs(query: String) async {
        guard authorizationStatus == .authorized else { return }

        do {
            var request = MusicCatalogSearchRequest(term: query, types: [Song.self])
            request.limit = 25

            let response = try await request.response()
            await MainActor.run {
                self.songs = Array(response.songs)
            }

        } catch {
            print("Error searching songs: \(error)")
        }
    }

    func previewURL(for song: Song) -> URL? {
        song.previewAssets?.first?.url
    }
}
