//
//  SeriesView.swift
//  Musinepolis
//
//  Created by José Miguel Guerrero Jiménez on 05/11/25.
//

import SwiftUI

struct SeriesView: View {
    var body: some View {
        CategoryTVSeriesView()
            .environment(ModelDataSoundtrack())
    }
}

#Preview {
    SeriesView()
}
