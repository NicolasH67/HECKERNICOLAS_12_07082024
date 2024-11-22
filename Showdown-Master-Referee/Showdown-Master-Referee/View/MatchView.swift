//  MatchView.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 21/10/2024.
//

import SwiftUI

struct MatchView: View {
    @EnvironmentObject var matchGestion: MatchGestion
    
    var body: some View {
        ZStack {
            Color(.systemRed)
                .opacity(0.3)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                // Header avec les noms des joueurs
                HStack {
                    Text(matchGestion.matchModel?.playerOne ?? "Player One")
                        .font(.headline)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Text(matchGestion.matchModel?.bestOf ?? "Best Of")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    Text(matchGestion.matchModel?.playerTwo ?? "Player Two")
                        .font(.headline)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(.horizontal)
                
                // Scores
                HStack(spacing: 40) {
                    ScoreBoxView(title: "Points", value: matchGestion.pointsPlayerOne)
                        .animation(.easeInOut(duration: 0.2), value: matchGestion.pointsPlayerOne)
                    ScoreBoxView(title: "Sets", value: matchGestion.setWinPlayerOne)
                        .animation(.easeInOut(duration: 0.2), value: matchGestion.setWinPlayerOne)
                    Spacer()
                    ScoreBoxView(title: "Sets", value: matchGestion.setWinPlayerTwo)
                        .animation(.easeInOut(duration: 0.2), value: matchGestion.setWinPlayerTwo)
                    ScoreBoxView(title: "Points", value: matchGestion.pointsPlayerTwo)
                        .animation(.easeInOut(duration: 0.2), value: matchGestion.pointsPlayerTwo)
                }
                
                // Actions des joueurs
                HStack(spacing: 40) {
                    PlayerActionView(
                        totalService: matchGestion.matchModel?.numberOfService ?? 0,
                        currentService: matchGestion.numberOfServicePlayerOne,
                        onGoal: {
                            matchGestion.onGoal(isPlayerOneScored: true)
                        },
                        onFault: {
                            matchGestion.onFault(isPlayerOneFault: true)
                        },
                        onServe: {
                            matchGestion.onServe()
                        },
                        startCountdown: {
                            matchGestion.stopCountdown()
                        },
                        initializeFirstServe: {
                            matchGestion.initializeServiceCounts()
                        },
                        matchIsOver: matchGestion.matchIsOver
                    )
                    PlayerActionView(
                        totalService: matchGestion.matchModel?.numberOfService ?? 0,
                        currentService: matchGestion.numberOfServicePlayerTwo,
                        onGoal: {
                            matchGestion.onGoal(isPlayerOneScored: false)
                        },
                        onFault: {
                            matchGestion.onFault(isPlayerOneFault: false)
                        },
                        onServe: {
                            matchGestion.onServe()
                        },
                        startCountdown: {
                            matchGestion.stopCountdown()
                        },
                        initializeFirstServe: {
                            matchGestion.initializeServiceCounts()
                        },
                        matchIsOver: matchGestion.matchIsOver
                    )
                }
                
                // Boutons d'action
                VStack(spacing: 10) {
                    Button(action: {
                        matchGestion.undoLastAction()
                        matchGestion.undoLastAction()
                    }) {
                        Text("Cancel last")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    Button(action: matchGestion.startCountdown) {
                        Text("Start Chrono")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    Button(action: matchGestion.resetSet) {
                        Text("End of Set")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                }
                .padding(.horizontal, 30)
            }
            .padding()
        }
        .sheet(isPresented: $matchGestion.showCountdownPopup, onDismiss: matchGestion.stopCountdown) {
            CountdownPopup(countdownTime: $matchGestion.countdownTime, onDismiss: matchGestion.stopCountdown)
        }
        .onAppear {
            matchGestion.initializeServiceCounts()
        }
    }
}

#Preview {
    MatchView()
}
