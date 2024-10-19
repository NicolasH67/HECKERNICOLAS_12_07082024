//
//  BestOf.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 17/10/2024.
//

import SwiftUI

struct BestOf: View {
    @State var bestOfSelectedPicker: Int = 0
    let pickerBestOfLabels: [String] = ["1", "3", "5", "Team", "Custom"]
    
    var body: some View {
        Text("Best Of")
            .font(.headline)
            .padding(.leading)

        Picker(selection: $bestOfSelectedPicker, label: Text("Best Of")) {
            ForEach(0 ..< pickerBestOfLabels.count, id: \.self) { index in
                Text(pickerBestOfLabels[index]).tag(index)
            }
        }
        .pickerStyle(.segmented)
        .padding()
    }
}

#Preview {
    BestOf()
}
