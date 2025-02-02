//
//  CountdownPopup.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 21/11/2024.
//

import SwiftUI

/// A popup view displaying the countdown timer and match details.
///
/// This view provides functionalities such as:
/// - Displaying the remaining countdown time.
/// - Showing stats for two players, including scores, sets, and services.
/// - Allowing the user to add more time to the countdown or dismiss the popup.
///
/// - Parameters:
///   - `countdownTime`: A `Binding` to the remaining countdown time in seconds.
///   - `playerOneName`: The name of Player 1.
///   - `playerTwoName`: The name of Player 2.
///   - `coachPlayerOneName`: The name of the coach for Player 1.
///   - `coachPlayerTwoName`: The name of the coach for Player 2.
///   - `playerOneScore`: The score of Player 1.
///   - `playerTwoScore`: The score of Player 2.
///   - `playerOneSets`: The number of sets won by Player 1.
///   - `playerTwoSets`: The number of sets won by Player 2.
///   - `playerOneService`: The number of services performed by Player 1.
///   - `playerTwoService`: The number of services performed by Player 2.
///   - `onDismiss`: A closure executed when the popup is dismissed.
///   - `onMore5`: A closure executed when 5 seconds are added to the countdown.
///   - `onMore10`: A closure executed when 10 seconds are added to the countdown.
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
    var playerOneService: Int
    var playerTwoService: Int
    var onDismiss: () -> Void
    var onMore5: () -> Void
    var onMore10: () -> Void

    var body: some View {
        ZStack {
            Color.red.opacity(0.3)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("Match Timer")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color("Raspberry Pink"))

                Text("\(countdownTime)")
                    .font(.system(size: 72, weight: .bold, design: .monospaced))
                    .foregroundColor(Color("Deep Purple"))
                    .padding()
                    .background(Color.white.opacity(0.4))
                    .cornerRadius(15)
                    .shadow(color: Color("Deep Purple").opacity(0.5), radius: 10, x: 0, y: 5)

                HStack(spacing: 20) {
                    PlayerStatsView(
                        playerName: playerOneName,
                        score: playerOneScore,
                        sets: playerOneSets,
                        serviceNumber: playerOneService,
                        alignment: .leading
                    )

                    Divider()
                        .frame(height: 120)
                        .background(Color.white.opacity(0.5))

                    PlayerStatsView(
                        playerName: playerTwoName,
                        score: playerTwoScore,
                        sets: playerTwoSets,
                        serviceNumber: playerTwoService,
                        alignment: .trailing
                    )
                }
                .padding(.horizontal, 20)

                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Text("Coach (Player 1):")
                            .fontWeight(.bold)
                            .foregroundColor(Color("Deep Purple"))
                        Spacer()
                        Text(coachPlayerOneName)
                            .foregroundColor(Color("Raspberry Pink"))
                    }

                    HStack {
                        Text("Coach (Player 2):")
                            .fontWeight(.bold)
                            .foregroundColor(Color("Deep Purple"))
                        Spacer()
                        Text(coachPlayerTwoName)
                            .foregroundColor(Color("Raspberry Pink"))
                    }
                }
                .font(.body)
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(12)
                
                HStack {
                    Button(action: {
                        onMore5()
                    }) {
                        Text("+5")
                            .font(.headline)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("Deep Purple"))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        onMore10()
                    }) {
                        Text("+10")
                            .font(.headline)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("Raspberry Pink"))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal, 50)

                Button(action: onDismiss) {
                    Text("Dismiss")
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
                        .cornerRadius(12)
                        .shadow(color: Color("Deep Purple").opacity(0.5), radius: 8, x: 0, y: 4)
                }
                .padding(.horizontal, 50)
                .padding(.top, 10)
            }
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.4), radius: 20, x: 0, y: 10)
            .padding(.horizontal, 20)
        }
    }
}

struct PlayerStatsView: View {
    var playerName: String
    var score: Int
    var sets: Int
    var serviceNumber: Int
    var alignment: HorizontalAlignment

    var body: some View {
        VStack(alignment: alignment, spacing: 8) {
            Text(playerName)
                .font(.headline)
                .foregroundColor(Color("Deep Purple"))
                .lineLimit(1)
                .truncationMode(.tail)

            Text("Service: \(serviceNumber)")
                .font(.subheadline)
                .foregroundColor(Color("Raspberry Pink"))

            HStack(spacing: 10) {
                VStack {
                    Text("Score")
                        .font(.caption)
                        .foregroundColor(.black.opacity(0.7))
                    Text("\(score)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color("Deep Purple"))
                }
                VStack {
                    Text("Sets")
                        .font(.caption)
                        .foregroundColor(.black.opacity(0.7))
                    Text("\(sets)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color("Raspberry Pink"))
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}
