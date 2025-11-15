//
//  TVSeriesDetail.swift
//  Musinepolis
//
//  Created by José Miguel Guerrero Jiménez on 07/11/25.
//



import SwiftUI
import MusicKit

struct TVSeriesDetail: View {
    @Environment(ModelDataSoundtrack.self) var modelData
    @StateObject private var viewModel = PlaylistSongsViewModel()
    var serie: TVSerie
    
    var serieIndex: Int? {
        modelData.tvSeries.firstIndex(where: { $0.id == serie.id })
    }
    
    var body: some View {
        ZStack {
            // Fondo con blur
            AsyncImage(url: URL(string: serie.posterPath)) { phase in
                switch phase {
                case .empty:
                    Color.black.opacity(0.6)
                case .success(let image):
                    image
                        .resizable()
                        .blur(radius: 20)
                        .overlay(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.black.opacity(0.1),
                                    Color.black.opacity(0.2),
                                    Color.clear
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .ignoresSafeArea()
                case .failure:
                    Color.black.opacity(0.6)
                @unknown default:
                    EmptyView()
                }
            }
            .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    // 📺 Imagen del póster
                    AsyncImage(url: URL(string: serie.posterPath)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(height: 300)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(12)
                                .shadow(radius: 8)
                        case .failure:
                            Image(systemName: "tv")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 300)
                                .foregroundColor(.gray)
                        @unknown default:
                            EmptyView()
                        }
                    }
                    
                    // 📜 Información general
                    VStack(alignment: .leading, spacing: 8) {
                        Text(serie.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text(serie.overview)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    // 🎵 Lista de canciones
                    if viewModel.isLoading {
                        ProgressView("Cargando soundtrack…")
                            .frame(maxWidth: .infinity)
                    } else if viewModel.songs.isEmpty {
                        Text("No se encontraron canciones para esta serie.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    } else {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Soundtrack")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .padding(.bottom, 5)
                            
                            ForEach(viewModel.songs) { song in
                                HStack(spacing: 10) {
                                    // Artwork de Apple Music
                                    if let artwork = song.artwork {
                                        ArtworkImage(artwork, width: 60, height: 60)
                                            .cornerRadius(8)
                                    } else {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(width: 60, height: 60)
                                            .overlay(
                                                Image(systemName: "music.note")
                                                    .foregroundColor(.gray)
                                            )
                                    }
                                    
                                    // Información de la canción
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(song.title)
                                            .font(.headline)
                                            .lineLimit(1)
                                        
                                        Text(song.artistName)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                            .lineLimit(1)
                                    }
                                    
                                    Spacer()
                                    
                                    // Botón de preview
                                    if song.previewAssets?.first != nil {
                                        Button {
                                            viewModel.playPreview(song)
                                        } label: {
                                            Image(systemName: "play.circle.fill")
                                                .font(.title2)
                                                .foregroundColor(.pink)
                                        }
                                    } else {
                                        Image(systemName: "play.circle")
                                            .font(.title2)
                                            .foregroundColor(.gray.opacity(0.5))
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle(serie.name)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            try? await Task.sleep(for: .seconds(0.3))
            
            // Buscar por nombre del soundtrack o nombre de la serie
            let searchQuery = serie.name ?? "\(serie.name) soundtrack"
            await viewModel.fetchSongs(playlistName: searchQuery)
        }
        .onDisappear {
            viewModel.stopPreview()
        }
    }
}

#Preview {
    let modelData = ModelDataSoundtrack()
    if let firstSerie = modelData.tvSeries.first {
        TVSeriesDetail(serie: firstSerie)
            .environment(modelData)
    } else {
        Text("No tv series data available")
    }
}
