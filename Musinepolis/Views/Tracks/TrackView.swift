//
//  TrackView.swift
//  Musinepolis
//
//  Created by José Miguel Guerrero Jiménez on 10/11/25.
//

import SwiftUI

struct TrackView: View {
    @StateObject private var viewModel = TracksViewModel()
    @State private var query: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                // Barra de búsqueda
                HStack {
                    TextField("Buscar soundtrack...", text: $query)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button("Buscar") {
                        Task {
                            await viewModel.fetchTracks(query: query)
                        }
                    }
                }
                .padding()
                
                // Lista de tracks
                if viewModel.isLoading {
                    ProgressView("Cargando...")
                        .padding()
                } else if viewModel.tracks.isEmpty {
                    Spacer()
                    Text("Busca tu soundtrack favorito")
                        .foregroundColor(.gray)
                    Spacer()
                } else {
                    List(viewModel.tracks) { track in
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                if let imageUrl = track.album?.images.first?.url,
                                   let url = URL(string: imageUrl) {
                                    AsyncImage(url: url) { image in
                                        image.resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 60, height: 60)
                                            .cornerRadius(8)
                                    } placeholder: {
                                        ProgressView()
                                            .frame(width: 60, height: 60)
                                    }
                                }
                                
                                VStack(alignment: .leading) {
                                    Text(track.name)
                                        .font(.headline)
                                    Text(track.artists.map(\.name).joined(separator: ", "))
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            if let _ = track.previewURL {
                                Button("🎧 Escuchar preview") {
                                    viewModel.playPreview(track.previewURL)
                                }
                                .buttonStyle(.bordered)
                            } else {
                                Text("Sin preview disponible")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.vertical, 5)
                    }
                }
                
                Spacer()
            }
            .navigationTitle("Soundtracks")
        }
    }
}


