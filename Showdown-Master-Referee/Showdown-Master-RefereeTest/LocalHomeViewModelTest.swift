//
//  LocalHomeViewModelTest.swift
//  Showdown-Master-RefereeTest
//
//  Created by Nicolas Hecker on 02/01/2025.
//

import Testing
@testable import Showdown_Master_Referee

struct LocalHomeViewModelTest {

    @Test func functionTest() {
        let viewModel = LocalHomeViewModel()
        viewModel.playerOneName = "Player One"
        viewModel.playerTwoName = "Player Two"
        viewModel.coachPlayerOneName = "Coach One"
        viewModel.coachPlayerTwoName = "Coach Two"
        viewModel.changeSide = true
        viewModel.pointsPerSet = 11
        viewModel.numberOfSet = 3
        viewModel.bestOfSelectedPicker = 1
        viewModel.numberOfService = 2
        viewModel.firstServeSelectedPicker = 0
        viewModel.startMatch()
        #expect(viewModel.matchModel?.playerOne == "Player One")
        #expect(viewModel.matchModel?.playerTwo == "Player Two")
        #expect(viewModel.matchModel?.coachPlayerOne == "Coach One")
        #expect(viewModel.matchModel?.coachPlayerTwo == "Coach Two")
        #expect(viewModel.matchModel?.changeSide == true)
        #expect(viewModel.matchModel?.numberOfPoints == 11)
        #expect(viewModel.matchModel?.numberOfSet == 3)
        #expect(viewModel.matchModel?.bestOf == "Best of 3")
        #expect(viewModel.matchModel?.playerOneFirstServe == true)
        #expect(viewModel.matchModel?.numberOfService == 2)
    }

}
