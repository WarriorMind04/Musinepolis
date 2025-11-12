//
//  TVSeriesDetail.swift
//  Musinepolis
//
//  Created by José Miguel Guerrero Jiménez on 07/11/25.
//

import SwiftUI

struct TVSeriesDetail: View {
    @Environment(ModelDataSoundtrack.self) var modelData
    @StateObject private var viewModel = TracksViewModel()
    var serie: TVSerie
    
    var serieIndex: Int? {
        modelData.tvSeries.firstIndex(where: { $0.id == serie.id })
    }
    
    var body: some View {
        ZStack{ AsyncImage(url: URL(string: serie.posterPath)) { phase in
            switch phase {
            case .empty:
                Color.black.opacity(0.6) // fondo mientras carga
            case .success(let image):
                image
                    .resizable()
                //.scaledToFill()
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
                VStack {
                    // ✅ Usa AsyncImage directamente para cargar desde la URL
                    AsyncImage(url: URL(string: serie.posterPath)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(height: 300)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity)
                                .cornerRadius(12)
                                .shadow(radius: 8)
                        case .failure:
                            Image(systemName: "film")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 300)
                                .foregroundColor(.gray)
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .padding(.bottom, 10)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text(serie.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Divider()
                        
                        Text("About \(serie.name)")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text(serie.overview)
                            .font(.body)
                            .foregroundColor(.secondary)
                        Divider()
                            .padding(.vertical, 8)
                        
                        // 🎵 Lista de canciones
                        if viewModel.isLoading {
                            ProgressView("Cargando soundtrack…")
                                .frame(maxWidth: .infinity)
                        } else if viewModel.tracks.isEmpty {
                            Text("No se encontraron canciones para esta película.")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        } else {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Soundtrack")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .padding(.bottom, 5)
                                
                                ForEach(viewModel.tracks) { track in
                                    HStack(spacing: 10) {
                                        // Imagen del álbum
                                        if let imageUrl = track.album?.images.first?.url,
                                           let url = URL(string: imageUrl) {
                                            AsyncImage(url: url) { image in
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: 60, height: 60)
                                                    .cornerRadius(8)
                                            } placeholder: {
                                                ProgressView()
                                                    .frame(width: 60, height: 60)
                                            }
                                        }
                                        
                                        // Información del track
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(track.name)
                                                .font(.headline)
                                            Text(track.artists.map(\.name).joined(separator: ", "))
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                        }
                                        
                                        Spacer()
                                        
                                        // Botón de preview (si existe)
                                        if let preview = track.previewURL {
                                            Button {
                                                viewModel.playPreview(preview)
                                            } label: {
                                                Image(systemName: "play.circle.fill")
                                                    .font(.title2)
                                                    .foregroundColor(.green)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                    }
                    .padding()
                }}
        }
        .navigationTitle(serie.name)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            //await viewModel.loadDefaultTracks(for: serie.name)
            try? await Task.sleep(for: .seconds(0.3))
            await viewModel.fetchTracksPlaylist(for: serie.albumId)
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
