//
//  NetworkHomeViewModel.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 15/12/2024.
//

import SwiftUI

class NetworkHomeViewModel: ObservableObject {
    @Published var coachPlayerOneName = ""
    @Published var coachPlayerTwoName = ""
    @Published var bestOfSelectedPicker = 0
    @Published var numberOfSet = 1
    @Published var pointsPerSet = 11
    @Published var numberOfService = 2
    @Published var changeSide = true
    @Published var firstServeSelectedPicker = 0
    @Published var isMatchModelReady = false
    @Published var matchModel: MatchModel?

    var playerOneName: String
    var playerTwoName: String
    var matchId: String
    var tournamentId: String
    var refereePassword: String

    private let bestOfOptions = ["Best of 1", "Best of 3", "Best of 5", "Team", "Custom"]

    init( playerOneName: String, playerTwoName: String, matchId: String, tournamentId: String, refereePassword: String) {
        self.playerOneName = playerOneName
        self.playerTwoName = playerTwoName
        self.matchId = matchId
        self.tournamentId = tournamentId
        self.refereePassword = refereePassword
    }

    func startMatch() {
        let playerOneServeChoice = (firstServeSelectedPicker == 0)

        matchModel = MatchModel(
            playerOne: playerOneName,
            playerTwo: playerTwoName,
            coachPlayerOne: coachPlayerOneName,
            coachPlayerTwo: coachPlayerTwoName,
            numberOfService: numberOfService,
            numberOfPoints: pointsPerSet,
            numberOfSet: numberOfSet,
            bestOf: bestOfOptions[bestOfSelectedPicker],
            playerOneFirstServe: playerOneServeChoice,
            changeSide: changeSide,
            matchId: matchId,
            tournamentId: tournamentId,
            refereePassword: refereePassword
        )
        isMatchModelReady = true
    }
}
