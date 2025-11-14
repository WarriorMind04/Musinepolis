//
//  CardsCarrusel.swift
//  Musinepolis
//
//  Created by José Miguel Guerrero Jiménez on 05/11/25.
//


import SwiftUI

struct CardsCarrusel<Item: Identifiable>: View {
    let items: [Item]
    let imageURL: (Item) -> String

    var body: some View {
        GeometryReader { outerGeo in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(items, id: \.id) { item in
                        GeometryReader { geo in
                            let midX = geo.frame(in: .global).midX
                            let screenMidX = outerGeo.size.width / 2
                            let distance = abs(screenMidX - midX)
                            let scale = max(0.8, 1 - distance / 600)
                            let rotation = (screenMidX - midX) / 20
                            
                            AsyncImage(url: URL(string: imageURL(item))) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                        .frame(width: 300, height: 480)
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 300, height: 480)
                                        .clipped()
                                case .failure:
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                        .foregroundColor(.gray)
                                        .frame(width: 300, height: 480)
                                        .background(Color.gray.opacity(0.2))
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            .cornerRadius(20)
                            .shadow(radius: 10)
                            .scaleEffect(scale)
                            .rotation3DEffect(
                                .degrees(Double(rotation)),
                                axis: (x: 0, y: 1, z: 0)
                            )
                            .animation(.easeOut(duration: 0.3), value: scale)
                        }
                        .frame(width: 300, height: 480)
                    }
                }
                .padding(.horizontal, (outerGeo.size.width - 500) / 2)
                .padding(.vertical, 0)
            }
        }
        .frame(height: 500)
    }
}

#Preview {
    CardsCarrusel(items: ModelDataSoundtrack().movies) { movie in
        movie.posterPath
    }
}
