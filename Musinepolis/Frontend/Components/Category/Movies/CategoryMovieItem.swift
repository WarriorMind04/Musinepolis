//
//  CategoryMovieItem.swift
//  Musinepolis
//
//  Created by José Miguel Guerrero Jiménez on 07/11/25.
//

import SwiftUI

struct CategoryMovieItem: View {
    var movie: Movie

    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: movie.posterPath)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 155, height: 155)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 155, height: 155)
                        .clipped()
                        .cornerRadius(5)
                case .failure:
                    Image(systemName: "film")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 155, height: 155)
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }

            Text(movie.title)
                .foregroundStyle(.primary)
                .font(.caption)
                .lineLimit(1)
        }
        .padding(.leading, 15)
    }
}

#Preview {
    let model = ModelDataSoundtrack()
    if let movie = model.movies.first {
        CategoryMovieItem(movie: movie)
    } else {
        Text("No preview data")
    }
}

