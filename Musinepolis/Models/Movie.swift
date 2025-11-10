//
//  Movie.swift
//  Musinepolis
//
//  Created by José Miguel Guerrero Jiménez on 07/11/25.
//

import Foundation
import SwiftUI

struct Movie: Codable, Identifiable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String
    //var isFavorite: Bool
    let albumId: Int?
    
    var category: Category
    enum Category: String, CaseIterable, Codable {
        case new = "New Releases"
        case featured = "Featured Movies"
        case top = "Top Movies"
    }
    /*private var imageName: String
    var image: Image {
        Image(imageName)
    }*/
    // 💡 Computed property para cargar imagen desde URL
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
