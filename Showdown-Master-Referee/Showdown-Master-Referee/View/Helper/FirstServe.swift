//
//  FirstServe.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 17/10/2024.
//

import SwiftUI

struct FirstServe: View {
    let pickerFirstServeLabels: [String] = ["Player One", "Player Two"]
    @State var firstServeSelectedPicker: Int = 0
    var body: some View {
        Text("First Serve")
            .font(.headline)
            .padding(.leading)

        Picker(selection: $firstServeSelectedPicker, label: Text("First Serve")) {
            ForEach(0 ..< pickerFirstServeLabels.count, id: \.self) { index in
                Text(pickerFirstServeLabels[index]).tag(index)
            }
        }
        .pickerStyle(.segmented)
        .padding()
    }
}

#Preview {
    FirstServe()
}
