//
//  PlayerEntryView.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 03/12/2024.
//

import SwiftUI

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
