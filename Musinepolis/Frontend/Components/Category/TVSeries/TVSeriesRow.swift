//
//  TVSeriesRow.swift
//  Musinepolis
//
//  Created by José Miguel Guerrero Jiménez on 07/11/25.
//

import SwiftUI

struct TVSeriesRow: View {
    var categoryName: String
    var items: [TVSerie]

    var body: some View {
        VStack(alignment: .leading) {
            Text(categoryName)
                .font(.headline)
                .padding(.leading, 15)
                .padding(.top, 5)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(items) { serie in
                        NavigationLink {
                            TVSeriesDetail(serie: serie)
                        } label: {
                            TVSeriesItem(serie: serie)
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
    let firstCategory = modelData.serieCategories.keys.sorted().first ?? "TV Series"
    let items = modelData.serieCategories[firstCategory] ?? []
    return TVSeriesRow(categoryName: firstCategory, items: items)
        .environment(modelData)
}
