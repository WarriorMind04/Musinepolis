//
//  TVSeriesItem.swift
//  Musinepolis
//
//  Created by José Miguel Guerrero Jiménez on 07/11/25.
//

import SwiftUI

struct TVSeriesItem: View {
    var serie: TVSerie

    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: serie.posterPath)) { phase in
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

            Text(serie.name)
                .foregroundStyle(.primary)
                .font(.caption)
                .lineLimit(1)
        }
        .padding(.leading, 15)
    }

}

#Preview {
    let model = ModelDataSoundtrack()
    if let serie = model.tvSeries.first {
        TVSeriesItem(serie: serie)
    } else {
        Text("No preview data")
    }
}
