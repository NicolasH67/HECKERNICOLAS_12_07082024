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
            ZStack {
                LinearGradient(
                    colors: [Color("Deep Purple"), Color("Raspberry Pink")],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .opacity(0.9)
                .cornerRadius(10)
                .shadow(color: Color.blue.opacity(0.5), radius: 10, x: 0, y: 5)
                
                HStack(spacing: 10) {
                    Image(systemName: "play.circle.fill")
                        .font(.title)
                        .foregroundColor(.white)
                    Text("Start Game")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .padding()
            }
        }
        .padding(.horizontal)
    }
}
