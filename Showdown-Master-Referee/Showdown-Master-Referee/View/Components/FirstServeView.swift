//
//  FirstServe.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 17/10/2024.
//

import SwiftUI


/// A view for selecting which player will perform the first serve.
///
/// This view uses a segmented picker to allow the user to select between two options: "Player One" or "Player Two".
///
/// - Parameters:
///   - `pickerFirstServeLabels`: An array of labels used for the segmented picker (default: ["Player One", "Player Two"]).
///   - `firstServeSelectedPicker`: A `Binding` to an integer representing the selected index (0 for "Player One", 1 for "Player Two").
struct FirstServeView: View {
    let pickerFirstServeLabels: [String] = ["Player One", "Player Two"]
    @Binding var firstServeSelectedPicker: Int
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
    FirstServeView(firstServeSelectedPicker: .constant(0))
}
