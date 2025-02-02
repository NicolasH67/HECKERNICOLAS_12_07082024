//  MatchView.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 21/10/2024.
//

import SwiftUI

/// View for displaying and controlling the match state, including scores, actions, and match progression.
struct MatchView: View {
    @StateObject private var viewModel: MatchViewModel
    @Binding var path: NavigationPath
    var networkManager: NetworkManager?
    let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)

    /// Initializes the `MatchView` with a match model, optional network manager, and navigation path.
    init(matchModel: MatchModel, networkManager: NetworkManager? = nil, path: Binding<NavigationPath>) {
        self.networkManager = networkManager
        self._path = path
        _viewModel = StateObject(wrappedValue: MatchViewModel(matchModel: matchModel, networkManager: networkManager))
    }

    /// Body of the view that displays players, score boxes, actions, and match buttons.
    var body: some View {
        ZStack {
            Color(.red)
                .opacity(0.3)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                HStack {
                    Text(viewModel.matchModel.playerOne)
                        .font(.headline)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .onTapGesture {
                            viewModel.onPlayerTap(player: viewModel.matchModel.playerOne,
                                                  coach: viewModel.matchModel.coachPlayerOne)
                        }

                    Text(viewModel.matchModel.bestOf)
                        .font(.headline)
                        .foregroundColor(.gray)

                    Text(viewModel.matchModel.playerTwo)
                        .font(.headline)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .onTapGesture {
                            viewModel.onPlayerTap(player: viewModel.matchModel.playerTwo,
                                                  coach: viewModel.matchModel.coachPlayerTwo)
                        }
                }
                .padding(.horizontal)

                HStack(spacing: 35) {
                    ScoreBoxView(title: "Points", value: viewModel.pointsPlayerOne)
                    ScoreBoxView(title: "Sets", value: viewModel.setWinPlayerOne)
                    Spacer()
                    ScoreBoxView(title: "Sets", value: viewModel.setWinPlayerTwo)
                    ScoreBoxView(title: "Points", value: viewModel.pointsPlayerTwo)
                }
                .padding()

                HStack(spacing: 40) {
                    PlayerActionView(
                        totalService: viewModel.matchModel.numberOfService,
                        currentService: viewModel.numberOfServicePlayerOne,
                        onGoal: { viewModel.onGoal(isPlayerOneScored: true) },
                        onFault: { viewModel.onFault(isPlayerOneFault: true) },
                        onServe: { viewModel.onServe() },
                        startCountdown: { viewModel.onStartChrono() },
                        showWarning: { viewModel.showWarning(isPlayerOne: true)},
                        initializeFirstServe: { viewModel.initializeServiceCounts() },
                        timeOutButtonIsDisabled: $viewModel.timeOutButtonIsDisabledPlayerOne,
                        matchIsOver: viewModel.matchIsOver
                    )
                    PlayerActionView(
                        totalService: viewModel.matchModel.numberOfService,
                        currentService: viewModel.numberOfServicePlayerTwo,
                        onGoal: { viewModel.onGoal(isPlayerOneScored: false) },
                        onFault: { viewModel.onFault(isPlayerOneFault: false) },
                        onServe: { viewModel.onServe() },
                        startCountdown: { viewModel.onStartChrono() },
                        showWarning: { viewModel.showWarning(isPlayerOne: false)},
                        initializeFirstServe: { viewModel.initializeServiceCounts() },
                        timeOutButtonIsDisabled: $viewModel.timeOutButtonIsDisabledPlayerTwo,
                        matchIsOver: viewModel.matchIsOver
                    )
                }
                
                ScrollView {
                    VStack(spacing: 10) {
                        Button(action: {
                            impactFeedback.impactOccurred()
                            viewModel.onCancelLastAction()
                        }) {
                            Text("Cancel Last")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color("Deep Purple"))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        Button(action: {
                            impactFeedback.impactOccurred()
                            viewModel.onStartChrono()
                        }) {
                            Text("Start Chrono")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color("Raspberry Pink"))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        Button(action: {
                            impactFeedback.impactOccurred()
                            viewModel.onEndOfSet()
                        }) {
                            Text("End of Set")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color("Raspberry Pink"))
                                .foregroundColor(Color.white)
                                .cornerRadius(10)
                        }
                        Button(action: {
                            impactFeedback.impactOccurred()
                            viewModel.onQuitMatch()
                        }) {
                            Text("Quit Match")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color("Deep Purple"))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding(.horizontal, 30)
            }
        }
        .navigationBarHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .onAppear {
            viewModel.initializeServiceCounts()
            viewModel.onQuitCallback = {
                path.removeLast(path.count)
            }
        }
        .sheet(isPresented: $viewModel.showWarningPopup, onDismiss: viewModel.dismissWarning) {
            WarningPopup(
                selectedOption: $viewModel.selectedWarning,
                playerName: viewModel.warningShowName,
                onWarning: {
                    guard viewModel.selectedWarning != nil else { return }
                    viewModel.onWarning(isPlayerOneWarning: viewModel.isPlayerOneWarning)
                }, onDismiss: viewModel.dismissWarning
            )
        }
        .sheet(isPresented: $viewModel.showCountdownPopup, onDismiss: viewModel.stopCountdown) {
            CountdownPopup(
                countdownTime: $viewModel.countdownTime,
                playerOneName: viewModel.matchModel.playerOne,
                playerTwoName: viewModel.matchModel.playerTwo,
                coachPlayerOneName: viewModel.matchModel.coachPlayerOne,
                coachPlayerTwoName: viewModel.matchModel.coachPlayerTwo,
                playerOneScore: viewModel.pointsPlayerOne,
                playerTwoScore: viewModel.pointsPlayerTwo,
                playerOneSets: viewModel.setWinPlayerOne,
                playerTwoSets: viewModel.setWinPlayerTwo,
                playerOneService: viewModel.numberOfServicePlayerOne,
                playerTwoService: viewModel.numberOfServicePlayerTwo,
                onDismiss: viewModel.stopCountdown,
                onMore5: viewModel.onMore5,
                onMore10: viewModel.onMore10
            )
        }
        .alert("Match in Progress", isPresented: $viewModel.showAlert) {
            Button("Quit", role: .destructive) {
                path.removeLast(path.count)
            }
            Button("Cancel", role: .cancel) {
                viewModel.showAlert = false
            }
        } message: {
            Text("Are you sure you want to leave? The match is not over yet.")
        }
        .alert("Coach \(viewModel.playerNameToShow)", isPresented: $viewModel.coachShowAlert) {
            Button("Ok", role: .cancel) { viewModel.coachShowAlert = false }
        } message: {
            Text("\(viewModel.coachNameToShow)")
        }
        .alert(isPresented: $viewModel.showAlertNetwork) {
            Alert(
                title: Text("Match Update"),
                message: Text(viewModel.alertMessageNetwork),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}
