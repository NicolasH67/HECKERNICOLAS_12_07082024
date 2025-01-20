//
//  NetworkHomeViewTest.swift
//  Showdown-Master-RefereeTest
//
//  Created by Nicolas Hecker on 15/01/2025.
//

import Testing
@testable import Showdown_Master_Referee

struct NetworkHomeViewTest {

    @Test("When match is started, match model is initialized and match details are set correctly")
    func whenMatchIsStarted_thenMatchModelIsInitializedAndMatchDetailsAreSetCorrectly() {
        let playerOneName = "Player One"
        let playerTwoName = "Player Two"
        let matchId = "1"
        let tournamentId = "1"
        let refereePassword = "password123"
        
        
        let viewModel = NetworkHomeViewModel(
            playerOneName: playerOneName,
            playerTwoName: playerTwoName,
            matchId: matchId,
            tournamentId: tournamentId,
            refereePassword: refereePassword
        )
        
        viewModel.coachPlayerOneName = "Coach One"
        viewModel.coachPlayerTwoName = "Coach Two"
        viewModel.bestOfSelectedPicker = 1
        viewModel.numberOfSet = 3
        viewModel.pointsPerSet = 11
        viewModel.numberOfService = 2
        viewModel.firstServeSelectedPicker = 0
        
        viewModel.startMatch()
        
        guard let matchModelUnwrapped = viewModel.matchModel else { return }
        
        #expect(viewModel.isMatchModelReady == true)
        #expect(matchModelUnwrapped.playerOne == playerOneName)
        #expect(matchModelUnwrapped.playerTwo == playerTwoName)
        #expect(matchModelUnwrapped.coachPlayerOne == "Coach One")
        #expect(matchModelUnwrapped.coachPlayerTwo == "Coach Two")
        #expect(matchModelUnwrapped.bestOf == "Best of 3")
        #expect(matchModelUnwrapped.numberOfSet == 3)
        #expect(matchModelUnwrapped.numberOfPoints == 11)
        #expect(matchModelUnwrapped.numberOfService == 2)
        #expect(matchModelUnwrapped.playerOneFirstServe == true)
        #expect(matchModelUnwrapped.isNetworkMatch == true)
        #expect(matchModelUnwrapped.matchId == matchId)
        #expect(matchModelUnwrapped.tournamentId == tournamentId)
        #expect(matchModelUnwrapped.refereePassword == refereePassword)
    }
}
