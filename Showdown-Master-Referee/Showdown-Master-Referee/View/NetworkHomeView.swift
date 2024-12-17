//
//  NetworkHome.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 17/10/2024.
//

import SwiftUI

struct NetworkHomeView: View {
    @StateObject private var viewModel: NetworkHomeViewModel

    init(playerOneName: String, playerTwoName: String) {
        _viewModel = StateObject(wrappedValue: NetworkHomeViewModel(playerOneName: playerOneName, playerTwoName: playerTwoName))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.red.opacity(0.3)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        SectionHeader(title: "Players and Coaches")

                        // Champs préremplis avec les noms des joueurs récupérés
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
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Setup Match")
            .navigationBarTitleDisplayMode(.inline)
            .fullScreenCover(isPresented: $viewModel.isMatchModelReady) {
                if let matchModel = viewModel.matchModel {
                    MatchView(matchModel: matchModel)
                } else {
                    Text("Match model is not readu.")
                }
            }
        }
    }
}

#Preview {
    NetworkHomeView(
        playerOneName: "Player 1",
        playerTwoName: "Player 2"
    )
}