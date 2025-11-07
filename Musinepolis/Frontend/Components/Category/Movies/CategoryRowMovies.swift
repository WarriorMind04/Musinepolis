//
//  CategoryRowMovies.swift
//  Musinepolis
//
//  Created by José Miguel Guerrero Jiménez on 07/11/25.
//

import SwiftUI

struct CategoryRowMovies: View {
    var categoryName: String
    var items: [Movie]

    var body: some View {
        VStack(alignment: .leading) {
            Text(categoryName)
                .font(.headline)
                .padding(.leading, 15)
                .padding(.top, 5)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(items) { movie in
                        NavigationLink {
                            MovieDetail(movie: movie)
                        } label: {
                            CategoryMovieItem(movie: movie)
                        }
                    }
                }
            }
            .frame(height: 185)
        }
    }
}

#Preview {
    let modelData = ModelDataSoundtrack()
    let firstCategory = modelData.movieCategories.keys.sorted().first ?? "Movies"
    let items = modelData.movieCategories[firstCategory] ?? []
    return CategoryRowMovies(categoryName: firstCategory, items: items)
        .environment(modelData)
}
