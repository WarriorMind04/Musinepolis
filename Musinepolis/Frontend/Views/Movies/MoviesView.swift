//
//  HomeView.swift
//  Musinepolis
//
//  Created by José Miguel Guerrero Jiménez on 05/11/25.
//

import SwiftUI

struct MoviesView: View {
    //let colors: [Color] = [.red, .blue, .yellow, .green, .purple]
    //@Environment(ModelData.self) var modelData
        var body: some View {
            VStack(spacing: 10){
                Spacer()
                //ScreenTitle(title: "Películas")
                
                //CardsCarrusel()
                CategoryMovieView()
                    .environment(ModelDataSoundtrack())
            }
            
        }
}

#Preview {
    MoviesView()
        //.environment(ModelData())
}
