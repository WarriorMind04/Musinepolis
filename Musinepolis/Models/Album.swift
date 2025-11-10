//
//  Album.swift
//  Musinepolis
//
//  Created by José Miguel Guerrero Jiménez on 07/11/25.
//

import Foundation

struct Album: Codable {
    let name: String
    let images: [SpotifyImage]
}
