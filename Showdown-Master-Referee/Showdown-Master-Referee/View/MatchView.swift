//  MatchView.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 21/10/2024.
//

import SwiftUI

struct MatchView: View {
    @EnvironmentObject var matchGestion: MatchGestion
    @Environment(\.presentationMode) var presentationMode
    @State private var showAlert = false
    @State private var coachShowAlert = false
    @State private var playerNameToShow: String = ""
    @State private var coachNameToShow: String = ""

    var body: some View {
        ZStack {
            Color(.red)
                .opacity(0.3)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                HStack {
                    Text(matchGestion.matchModel?.playerOne ?? "Player One")
                        .font(.headline)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .onTapGesture {
                            playerNameToShow = matchGestion.matchModel?.playerOne ?? "Player One"
                            coachNameToShow = matchGestion.matchModel?.coachPlayerOne ?? ""
                            coachShowAlert = true
                        }

                    Text(matchGestion.matchModel?.bestOf ?? "Best Of")
                        .font(.headline)
                        .foregroundColor(.gray)

                    Text(matchGestion.matchModel?.playerTwo ?? "Player Two")
                        .font(.headline)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .onTapGesture {
                            playerNameToShow = matchGestion.matchModel?.playerTwo ?? "Player Two"
                            coachNameToShow = matchGestion.matchModel?.coachPlayerTwo ?? ""
                            coachShowAlert = true
                        }
                }
                .padding(.horizontal)

                HStack(spacing: 35) {
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

                HStack(spacing: 40) {
                    PlayerActionView(
                        totalService: matchGestion.matchModel?.numberOfService ?? 0,
                        currentService: matchGestion.numberOfServicePlayerOne,
                        onGoal: { matchGestion.onGoal(isPlayerOneScored: true) },
                        onFault: { matchGestion.onFault(isPlayerOneFault: true) },
                        onServe: { matchGestion.onServe() },
                        startCountdown: { matchGestion.stopCountdown() },
                        initializeFirstServe: { matchGestion.initializeServiceCounts() },
                        matchIsOver: matchGestion.matchIsOver
                    )
                    PlayerActionView(
                        totalService: matchGestion.matchModel?.numberOfService ?? 0,
                        currentService: matchGestion.numberOfServicePlayerTwo,
                        onGoal: { matchGestion.onGoal(isPlayerOneScored: false) },
                        onFault: { matchGestion.onFault(isPlayerOneFault: false) },
                        onServe: { matchGestion.onServe() },
                        startCountdown: { matchGestion.stopCountdown() },
                        initializeFirstServe: { matchGestion.initializeServiceCounts() },
                        matchIsOver: matchGestion.matchIsOver
                    )
                }
                
                ScrollView {
                    VStack(spacing: 10) {
                        Button(action: {
                            matchGestion.undoLastAction()
                            matchGestion.undoLastAction()
                        }) {
                            Text("Cancel Last")
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
                        Button(action: {
                            showAlert = true
                        }) {
                            Text("Quit Match")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal, 30)
                }
            }
            .padding()
        }
        .sheet(isPresented: $matchGestion.showCountdownPopup, onDismiss: matchGestion.stopCountdown) {
            CountdownPopup(
                countdownTime: $matchGestion.countdownTime,
                playerOneName: matchGestion.matchModel?.playerOne ?? "Player One",
                playerTwoName: matchGestion.matchModel?.playerTwo ?? "Player Two",
                coachPlayerOneName: matchGestion.matchModel?.coachPlayerOne ?? "",
                coachPlayerTwoName: matchGestion.matchModel?.coachPlayerTwo ?? "",
                onDismiss: matchGestion.stopCountdown
            )
        }
        .navigationBarBackButtonHidden(true)
        .onDisappear {
            matchGestion.resetMatchData()
        }
        .onAppear {
            matchGestion.initializeServiceCounts()
        }
        .alert("Coach \(playerNameToShow)", isPresented: $coachShowAlert) {
            Button("Ok", role: .cancel) {
                coachShowAlert = false
            }
        } message: {
            Text("\(coachNameToShow)")
        }
        .alert("Match in Progress", isPresented: $showAlert) {
            Button("Quit", role: .destructive) {
                presentationMode.wrappedValue.dismiss()
            }
            Button("Cancel", role: .cancel) {
                showAlert = false
            }
        } message: {
            Text("Are you sure you want to leave? The match is not over yet.")
        }
    }
}

#Preview {
    MatchView()
}
