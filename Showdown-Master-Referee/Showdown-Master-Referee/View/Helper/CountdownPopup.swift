//
//  CountdownPopup.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 21/11/2024.
//

import SwiftUI

struct CountdownPopup: View {
    @Binding var countdownTime: Int
    var playerOneName: String
    var playerTwoName: String
    var coachPlayerOneName: String
    var coachPlayerTwoName: String
    var playerOneScore: Int
    var playerTwoScore: Int
    var playerOneSets: Int
    var playerTwoSets: Int
    var onDismiss: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Match Timer")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
                
                Text("\(countdownTime)")
                    .font(.system(size: 72, weight: .bold, design: .monospaced))
                    .foregroundColor(.yellow)
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(12)
                    .shadow(color: .yellow.opacity(0.7), radius: 8, x: 0, y: 0)
                    .scaleEffect(1.2) // Effet de zoom initial
                    .opacity(0.8)     // Opacité initiale pour l'animation
                    .animation(
                        .spring(response: 0.4, dampingFraction: 0.5, blendDuration: 0.2), // Animation fluide avec effet ressort
                        value: countdownTime
                    )
                    .scaleEffect(1) // Retour à l'échelle normale
                    .opacity(1)     // Opacité normale
                
                HStack(spacing: 20) {
                    PlayerStatsView(
                        playerName: playerOneName,
                        score: playerOneScore,
                        sets: playerOneSets,
                        alignment: .leading
                    )
                    
                    Divider()
                        .frame(height: 100)
                        .background(Color.white.opacity(0.5))
                    
                    PlayerStatsView(
                        playerName: playerTwoName,
                        score: playerTwoScore,
                        sets: playerTwoSets,
                        alignment: .trailing
                    )
                }
                .padding(.horizontal, 20)
                
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Text("Coach (Player 1):")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Spacer()
                        Text(coachPlayerOneName)
                            .foregroundColor(.white.opacity(0.9))
                    }
                    
                    HStack {
                        Text("Coach (Player 2):")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Spacer()
                        Text(coachPlayerTwoName)
                            .foregroundColor(.white.opacity(0.9))
                    }
                }
                .font(.body)
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(10)
                .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 5)
                .padding(.horizontal, 20)
                
                Button(action: onDismiss) {
                    Text("Dismiss")
                        .font(.headline)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(LinearGradient(
                            colors: [Color.red.opacity(0.8), Color.red],
                            startPoint: .leading,
                            endPoint: .trailing
                        ))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(color: .red.opacity(0.7), radius: 8, x: 0, y: 4)
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
}

struct PlayerStatsView: View {
    var playerName: String
    var score: Int
    var sets: Int
    var alignment: HorizontalAlignment

    var body: some View {
        VStack(alignment: alignment, spacing: 8) {
            Text(playerName)
                .font(.headline)
                .foregroundColor(.white)
                .lineLimit(1)
                .truncationMode(.tail)
            
            HStack(spacing: 10) {
                VStack {
                    Text("Score")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                    Text("\(score)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }
                VStack {
                    Text("Sets")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                    Text("\(sets)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}
