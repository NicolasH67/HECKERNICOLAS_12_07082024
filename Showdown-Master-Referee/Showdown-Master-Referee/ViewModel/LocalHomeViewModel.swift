//
//  LocalHomeViewModel.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 15/12/2024.
//

import SwiftUI
import Foundation

class LocalHomeViewModel: ObservableObject {
    @Published var playerOneName = ""
    @Published var playerTwoName = ""
    @Published var coachPlayerOneName = ""
    @Published var coachPlayerTwoName = ""
    @Published var bestOfSelectedPicker = 0
    @Published var numberOfSet = 1
    @Published var pointsPerSet = 11
    @Published var numberOfService = 2
    @Published var changeSide = true
    @Published var firstServeSelectedPicker = 0
    @Published var isMatchModelReady = false
    @Published var matchModel: MatchModel? // Stockage local du MatchModel
    
    private let bestOfOptions = ["Best of 1", "Best of 3", "Best of 5", "Team", "Custom"]
    
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
            isNetworkMatch: false,
            matchId: nil,
            tournamentId: nil,
            refereePassword: nil
        )
        
        isMatchModelReady = true
    }
}
