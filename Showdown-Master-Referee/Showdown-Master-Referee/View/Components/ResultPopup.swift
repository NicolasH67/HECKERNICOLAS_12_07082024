//
//  CountdownPopup.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 21/11/2024.
//

import SwiftUI

struct MatchResultPopup: View {
    var playerOneName: String
    var playerTwoName: String
    var matchResults: [Int]
    var onDismiss: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("Résultats du Match")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 10)

                VStack(spacing: 10) {
                    HStack {
                        Text(playerOneName)
                            .font(.headline)
                            .foregroundColor(.cyan)
                        Spacer()
                        Text(playerResults(for: 1))
                            .font(.body)
                            .foregroundColor(.white)
                    }

                    HStack {
                        Text(playerTwoName)
                            .font(.headline)
                            .foregroundColor(.orange)
                        Spacer()
                        Text(playerResults(for: 2))
                            .font(.body)
                            .foregroundColor(.white)
                    }
                    Text("If there is an error in this result, please contact the score table manager or the tournament director.")
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.horizontal, 10)
                }
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(10)
                .shadow(color: .black.opacity(0.5), radius: 8, x: 0, y: 4)
                .padding(.horizontal, 20)

                Button(action: onDismiss) {
                    Text("Close")
                        .font(.headline)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(color: .red.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .padding(.horizontal, 50)
                .padding(.top, 10)
            }
            .padding()
            .background(Color.black.opacity(0.9))
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.5), radius: 20, x: 0, y: 10)
            .padding(.horizontal, 20)
        }
    }

    private func playerResults(for player: Int) -> String {
        var playerScores: [Int] = []
        for (index, score) in matchResults.enumerated() {
            if player == 1 && index % 2 == 0 {
                playerScores.append(score)
            } else if player == 2 && index % 2 != 0 {
                playerScores.append(score)
            }
        }
        return playerScores.map { "\($0)" }.joined(separator: " ")
    }
}
