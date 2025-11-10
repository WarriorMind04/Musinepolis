//
//  SongModel.swift
//  Musinepolis
//
//  Created by José Miguel Guerrero Jiménez on 07/11/25.
//

import Foundation

struct Song: Codable {
    let id: String
    let title: String
    let album: String
    let duration: String
    let previewUrl: String
}
