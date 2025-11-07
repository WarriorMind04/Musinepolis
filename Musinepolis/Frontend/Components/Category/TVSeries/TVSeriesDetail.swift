//
//  TVSeriesDetail.swift
//  Musinepolis
//
//  Created by José Miguel Guerrero Jiménez on 07/11/25.
//

import SwiftUI

struct TVSeriesDetail: View {
    @Environment(ModelDataSoundtrack.self) var modelData
    var serie: TVSerie

    var serieIndex: Int? {
        modelData.tvSeries.firstIndex(where: { $0.id == serie.id })
    }

    var body: some View {
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
                }
                .padding()
            }
        }
        .navigationTitle(serie.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let modelData = ModelDataSoundtrack()
    if let firstSerie = modelData.tvSeries.first {
        TVSeriesDetail(serie: firstSerie)
            .environment(modelData)
    } else {
        Text("No movie data available")
    }
}
