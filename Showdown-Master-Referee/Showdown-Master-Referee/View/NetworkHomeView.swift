//
//  NetworkHome.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 17/10/2024.
//

import SwiftUI

struct NetworkHomeView: View {
    @StateObject private var viewModel: NetworkHomeViewModel
    @Binding var path: NavigationPath

    init(
        playerOneName: String,
        playerTwoName: String,
        matchId: String,
        tournamentId: String,
        refereePassword: String,
        path: Binding<NavigationPath>) {
        _viewModel = StateObject(wrappedValue:
                                    NetworkHomeViewModel(
                                        playerOneName: playerOneName,
                                        playerTwoName: playerTwoName,
                                        matchId: matchId,
                                        tournamentId: tournamentId,
                                        refereePassword: refereePassword
                                    ))
        self._path = path
    }

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Color.red.opacity(0.3)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        SectionHeader(title: "Players and Coaches")

                        PlayerEntryView(playerTitle: "Player One", name: .constant(viewModel.playerOneName), coachName: $viewModel.coachPlayerOneName, isEditable: false)
                        PlayerEntryView(playerTitle: "Player Two", name: .constant(viewModel.playerTwoName), coachName: $viewModel.coachPlayerTwoName, isEditable: false)

                        SectionHeader(title: "Match Settings")

                        BestOfView(
                            bestOfSelectedPicker: $viewModel.bestOfSelectedPicker,
                            numberOfSetInt: $viewModel.numberOfSet,
                            pointsPerSetInt: $viewModel.pointsPerSet,
                            numberOfServiceInt: $viewModel.numberOfService,
                            changeSide: $viewModel.changeSide
                        )

                        FirstServeView(firstServeSelectedPicker: $viewModel.firstServeSelectedPicker)

                        StartGameButton {
                            viewModel.startMatch()
                            if viewModel.isMatchModelReady {
                                if let matchModel = viewModel.matchModel {
                                    path.append(matchModel)
                                }
                            } else {
                                print("Match model is not ready.")
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Setup Match")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: MatchModel.self) { matchModel in
                MatchView(
                    matchModel: matchModel,
                    networkManager: NetworkManager(),
                    path: $path
                )
            }
        }
    }
}
