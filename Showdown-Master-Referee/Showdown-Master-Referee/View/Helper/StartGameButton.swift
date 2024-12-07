//
//  StartGameButton.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 04/12/2024.
//

import SwiftUI

struct StartGameButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "play.circle.fill")
                    .font(.title)
                Text("Start Game")
                    .font(.title2.bold())
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
        .padding(.horizontal)
    }
}
