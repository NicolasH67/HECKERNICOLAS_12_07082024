//
//  PlayerEntryView.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 03/12/2024.
//

import SwiftUI

/// A reusable view for entering player and coach information.
///
/// This view provides text fields for inputting the player's name and their coach's name, with the ability
/// to toggle editability based on the `isEditable` parameter.
///
/// - Parameters:
///   - `playerTitle`: A `String` used to label the player (e.g., "Player One", "Player Two").
///   - `name`: A `Binding` to the player's name, allowing real-time updates.
///   - `coachName`: A `Binding` to the player's coach's name, allowing real-time updates.
///   - `isEditable`: A `Bool` that determines if the text fields can be edited.
struct PlayerEntryView: View {
    let playerTitle: String
    @Binding var name: String
    @Binding var coachName: String
    var isEditable: Bool

    var body: some View {
        VStack(spacing: 10) {
            TextField("\(playerTitle) Name", text: $name)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
                .disabled(!isEditable)

            TextField("\(playerTitle) Coach Name", text: $coachName)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
        }
    }
}

#Preview {
    PlayerEntryView(playerTitle: "Player One",
                    name: .constant("John Doe"),
                    coachName: .constant("Jane Doe"),
                    isEditable: true
    )
}
