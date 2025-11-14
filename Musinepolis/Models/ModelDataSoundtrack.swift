//
//  ModelDataSoundtrack.swift
//  Musinepolis
//
//  Created by José Miguel Guerrero Jiménez on 07/11/25.
//

import Foundation
import Observation

@Observable
class ModelDataSoundtrack {
    // MARK: - Datos principales
    //var movies: [Movie] = safeLoad("movies.json")
    var movies: [Movie] = safeLoad("movies.json") {
            didSet {
                print("✅ Cargadas \(movies.count) películas")
            }
        }
    var tvSeries: [TVSerie] = safeLoad("tvseries.json")
    var games: [Game] = safeLoad("games.json")
    //var albums: [Album] = safeLoad("albums.json")
   // var songs: [Song] = safeLoad("songs.json")
    
    var featuredMovies: [Movie] {
        movies.filter { $0.category == .featured }
    }
    var featuredSeries: [TVSerie] {
        tvSeries.filter { $0.category == .featured }
    }
    var featuredGames: [Game] {
        games.filter { $0.category == .featured }
    }
    
    var movieCategories: [String: [Movie]] {
        Dictionary(grouping: movies, by: { $0.category.rawValue })
    }
    var serieCategories: [String: [TVSerie]] {
        Dictionary(grouping: tvSeries, by: { $0.category.rawValue })
    }
    var gameCategories: [String: [Game]] {
        Dictionary(grouping: games, by: { $0.category.rawValue })
    }
    
   /* var allMedia: [MediaItem] {
        let movieItems = movies.map {
            MediaItem(
                id: UUID(),
                title: $0.title,
                type: .movie,
                posterPath: $0.posterPath,
                overview: $0.overview,
                category: $0.category.rawValue
            )
        }
        let seriesItems = tvSeries.map {
            MediaItem(
                id: UUID(),
                title: $0.name,
                type: .series,
                posterPath: $0.posterPath,
                overview: $0.overview,
                category: $0.category.rawValue
            )
        }
        let gameItems = games.map {
            MediaItem(
                id: UUID(),
                title: $0.title,
                type: .game,
                posterPath: $0.posterPath,
                overview: $0.platform, // Game has no overview; use platform or "" as a fallback
                category: $0.category.rawValue
            )
        }
        return movieItems + seriesItems + gameItems
    }
    func searchMedia(query: String) -> [MediaItem] {
        guard !query.isEmpty else { return allMedia }
        return allMedia.filter {
            $0.title.localizedCaseInsensitiveContains(query) ||
            $0.overview.localizedCaseInsensitiveContains(query)
        }
    }*/
    
    
}

// Versión segura: en debug/previews no hace fatalError; devuelve vacío si no se puede cargar.
// Requiere que T sea array para poder devolver [].
private func safeLoad<T: Decodable>(_ filename: String) -> T where T: ExpressibleByArrayLiteral {
    do {
        return try strictLoad(filename) as T
    } catch {
        #if DEBUG
        print("safeLoad warning: \(filename) no se pudo cargar: \(error). Devolviendo vacío para permitir previews.")
        #endif
        return [] as T
    }
}

// Carga estricta que lanza error en vez de terminar el proceso
private func strictLoad<T: Decodable>(_ filename: String) throws -> T {
    let data: Data
    
    // Intenta varios bundles para mejorar compatibilidad con previews
    let candidates: [Bundle] = [.main, Bundle(for: ModelDataSoundtrack.self)]
    guard let url = candidates.compactMap({ $0.url(forResource: filename, withExtension: nil) }).first else {
        throw NSError(domain: "ModelDataSoundtrack", code: 1, userInfo: [NSLocalizedDescriptionKey: "Couldn't find \(filename) in available bundles."])
    }
    
    do {
        data = try Data(contentsOf: url)
    } catch {
        throw NSError(domain: "ModelDataSoundtrack", code: 2, userInfo: [NSLocalizedDescriptionKey: "Couldn't load \(filename): \(error)"])
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        throw NSError(domain: "ModelDataSoundtrack", code: 3, userInfo: [NSLocalizedDescriptionKey: "Couldn't parse \(filename) as \(T.self): \(error)"])
    }
}


