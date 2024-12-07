//
//  LocalHome.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 11/10/2024.
//

import SwiftUI

struct LocalHomeView: View {
    @EnvironmentObject var matchGestion: MatchGestion
    @State private var playerOneName = ""
    @State private var playerTwoName = ""
    @State private var coachPlayerOneName = ""
    @State private var coachPlayerTwoName = ""
    @State private var bestOfSelectedPicker = 0
    @State private var numberOfSet = 1
    @State private var pointsPerSet = 11
    @State private var numberOfService = 2
    @State private var changeSide = true
    @State private var firstServeSelectedPicker = 0
    @State private var isMatchModelReady = false

    private let bestOfOptions = ["Best of 1", "Best of 3", "Best of 5", "Team", "Custom"]

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.red)
                    .opacity(0.3)
                    .ignoresSafeArea()
                
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        SectionHeader(title: "Players and Coaches")

                        PlayerEntryView(playerTitle: "Player One", name: $playerOneName, coachName: $coachPlayerOneName, isEditable: true)
                        PlayerEntryView(playerTitle: "Player Two", name: $playerTwoName, coachName: $coachPlayerTwoName, isEditable: true)

                        SectionHeader(title: "Match Settings")

                        BestOfView(
                            bestOfSelectedPicker: $bestOfSelectedPicker,
                            numberOfSetInt: $numberOfSet,
                            pointsPerSetInt: $pointsPerSet,
                            numberOfServiceInt: $numberOfService,
                            changeSide: $changeSide
                        )

                        FirstServeView(firstServeSelectedPicker: $firstServeSelectedPicker)

                        StartGameButton {
                            startMatch()
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Setup Match")
            .navigationBarTitleDisplayMode(.inline)
            .fullScreenCover(isPresented: $isMatchModelReady) {
                MatchView()
            }
        }
    }

    private func startMatch() {
        let playerOneServeChoice = (firstServeSelectedPicker == 0)

        matchGestion.matchModel = MatchModel(
            playerOne: playerOneName,
            playerTwo: playerTwoName,
            coachPlayerOne: coachPlayerOneName,
            coachPlayerTwo: coachPlayerTwoName,
            numberOfService: numberOfService,
            numberOfPoints: pointsPerSet,
            numberOfSet: numberOfSet,
            bestOf: bestOfOptions[bestOfSelectedPicker],
            playerOneFirstServe: playerOneServeChoice,
            changeSide: changeSide
        )
        isMatchModelReady = true
    }
}

#Preview {
    LocalHomeView()
}
