//
//  TabBar.swift
//  Musinepolis
//
//  Created by José Miguel Guerrero Jiménez on 05/11/25.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView() {
            MoviesView().tabItem {
                Label("Movies", systemImage: "film.fill")
            }.tag(1)
            SeriesView().tabItem {
                Label("TV Series", systemImage: "tv.fill")
            }.tag(2)
            GamesView().tabItem {
                Label("Games", systemImage: "gamecontroller.fill")
            }.tag(3)
            SongSearchView().tabItem {
                Label("Songs", systemImage: "music.pages.fill")
            }.tag(4)
        }
    }
}

#Preview {
    TabBarView()
}
