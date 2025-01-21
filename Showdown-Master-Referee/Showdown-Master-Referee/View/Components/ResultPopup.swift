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
            Color.red.opacity(0.3)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("Match Result")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color("Raspberry Pink"))
                    .padding(.bottom, 10)

                VStack(spacing: 10) {
                    HStack {
                        Text(playerOneName)
                            .font(.headline)
                            .foregroundColor(Color("Deep Purple"))
                        Spacer()
                        Text(playerResults(for: 1))
                            .font(.body)
                            .foregroundColor(Color("Deep Purple"))
                    }

                    HStack {
                        Text(playerTwoName)
                            .font(.headline)
                            .foregroundColor(Color("Raspberry Pink"))
                        Spacer()
                        Text(playerResults(for: 2))
                            .font(.body)
                            .foregroundColor(Color("Raspberry Pink"))
                    }
                    Text("If there is an error in this result, please contact the score table manager or the tournament director.")
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color("Deep Purple"))
                        .padding(.horizontal, 10)
                }
                .padding()
                .background(Color.white.opacity(0.3))
                .cornerRadius(10)
                .shadow(color: .black.opacity(0.5), radius: 8, x: 0, y: 4)
                .padding(.horizontal, 20)

                Button(action: onDismiss) {
                    Text("Close")
                        .font(.headline)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(LinearGradient(
                            colors: [Color("Deep Purple"), Color("Raspberry Pink")],
                            startPoint: .leading,
                            endPoint: .trailing
                        ))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(color: .red.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .padding(.horizontal, 50)
                .padding(.top, 10)
            }
            .padding()
            .cornerRadius(20)
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
