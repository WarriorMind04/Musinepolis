//
//  TVSerie.swift
//  Musinepolis
//
//  Created by José Miguel Guerrero Jiménez on 07/11/25.
//

import Foundation
import SwiftUI

struct TVSerie: Codable, Identifiable {
    let id: Int
    let name: String
    let firstAirDate: String
    let posterPath: String
    let overview: String
    let albumId: String
    let soundtrackName: String?

    
    var category: Category
       enum Category: String, CaseIterable, Codable {
           case new = "New Releases"
           case featured = "Featured Series"
           case top = "Top Series"
       }
    var image: AsyncImage<some View> {
        AsyncImage(url: URL(string: posterPath)) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
            case .failure:
                Image(systemName: "film")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray)
            @unknown default:
                EmptyView()
            }
        }
    }
}
