//
//  CategoryView.swift
//  Musinepolis
//
//  Created by José Miguel Guerrero Jiménez on 05/11/25.
//

import SwiftUI

struct CategoryView: View {
    @Environment(ModelData.self) var modelData
    var body: some View {
        NavigationSplitView{
            List {
                modelData.features[0].image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 200)
                                    .clipped()
                                    .listRowInsets(EdgeInsets())
                            ForEach(modelData.categories.keys.sorted(), id: \.self) { key in
                                CategoryRow(categoryName: key, items: modelData.categories[key]!)

                            }
                            .listRowInsets(EdgeInsets())
                        }
                .navigationTitle("Movies")
        } detail: {
            Text("Select a landmark")
        }
    }
}

#Preview {
    CategoryView()
        .environment(ModelData())
}
