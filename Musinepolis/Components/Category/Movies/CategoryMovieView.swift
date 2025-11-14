//
//  CategoryView.swift
//  Musinepolis
//
//  Created by José Miguel Guerrero Jiménez on 05/11/25.
//

import SwiftUI

struct CategoryMovieView: View {
    @Environment(ModelDataSoundtrack.self) var modelData
    @State private var isSearch = ""
    
    /*var filteredMedia: [MediaItem] {
           modelData.searchMedia(query: isSearch)
       }*/
    
    var body: some View {
        
        NavigationSplitView {
            ScrollView {
                
                
                CardsCarrusel(items: ModelDataSoundtrack().movies) { movie in
                                   movie.posterPath
                               }
                               //.padding(.bottom, 30)
                

                // ✅ Lista por categorías
                ForEach(modelData.movieCategories.keys.sorted(), id: \.self) { key in
                    if let items = modelData.movieCategories[key] {
                        CategoryRowMovies(categoryName: key, items: items)
                    }
                }
                .listRowInsets(EdgeInsets())
            }
            .navigationTitle("Movies")
            .searchable(text: $isSearch, prompt: "Search for any soundtracks")
        } detail: {
            Text("Select a movie")
        }
    }
}


#Preview {
    CategoryMovieView()
        .environment(ModelDataSoundtrack())
}


