//
//  MatchViewModelTest.swift
//  Showdown-Master-RefereeTest
//
//  Created by Nicolas Hecker on 28/12/2024.
//

import Testing
@testable import Showdown_Master_Referee

struct MatchViewModelTest {
    let match = MatchModel(
        playerOne: "Player One",
        playerTwo: "Player Two",
        coachPlayerOne: "Coach One",
        coachPlayerTwo: "Coach Two",
        numberOfService: 2,
        numberOfPoints: 11,
        numberOfSet: 3,
        bestOf: "Best of 3",
        playerOneFirstServe: true,
        changeSide: true,
        isNetworkMatch: false,
        matchId: nil,
        tournamentId: nil,
        refereePassword: nil
    )

    @Test func playerOneGoal() {
        let viewModel = MatchViewModel(matchModel: match)
        viewModel.onGoal(isPlayerOneScored: true)
        #expect(viewModel.pointsPlayerOne == 2, "Player One should have 2 points after scoring a goal.")
        #expect(viewModel.pointsPlayerTwo == 0, "Player Two should have 0 points if Player One scores.")
    }
    
    @Test func playerTwoGoal() {
        let viewModel = MatchViewModel(matchModel: match)
        viewModel.onGoal(isPlayerOneScored: false)
        #expect(viewModel.pointsPlayerOne == 0, "Player One should have 0 points if Player Two scores.")
        #expect(viewModel.pointsPlayerTwo == 2, "Player Two should have 2 points after scoring a goal.")
    }
    
    @Test func playerOneFault() {
        let viewModel = MatchViewModel(matchModel: match)
        viewModel.onFault(isPlayerOneFault: true)
        
        #expect(viewModel.pointsPlayerOne == 0, "Player One should have 0 points")
        #expect(viewModel.pointsPlayerTwo == 1, "Player Two should have 1 point")
    }
    
    @Test func playerTwoFault() {
        let viewModel = MatchViewModel(matchModel: match)
        viewModel.onFault(isPlayerOneFault: false)
        
        #expect(viewModel.pointsPlayerOne == 1, "Player One should have 1 point")
        #expect(viewModel.pointsPlayerTwo == 0, "Player Two should have 0 points")
    }
    
    @Test func playerOneChangeServe(){
        let viewModel = MatchViewModel(matchModel: match)
        viewModel.numberOfServicePlayerOne = 1
        viewModel.numberOfServicePlayerTwo = 0
        viewModel.onServe()
        
        #expect(viewModel.numberOfServicePlayerOne == 2)
        #expect(viewModel.numberOfServicePlayerTwo == 0)
       
    }
    
    @Test func playerTwoChangeServe() {
        let viewModel = MatchViewModel(matchModel: match)
        viewModel.numberOfServicePlayerOne = 0
        viewModel.numberOfServicePlayerTwo = 1
        viewModel.onServe()
        
        #expect(viewModel.numberOfServicePlayerOne == 0)
        #expect(viewModel.numberOfServicePlayerTwo == 2)
    }
    
    @Test func playerTwoFirstServe() {
        let viewModel = MatchViewModel(matchModel: match)
        viewModel.numberOfServicePlayerOne = 2
        viewModel.numberOfServicePlayerTwo = 0
        viewModel.onServe()
        
        #expect(viewModel.numberOfServicePlayerOne == 0)
        #expect(viewModel.numberOfServicePlayerTwo == 1)
    }
    
    @Test func playerOneFirstServe() {
        let viewModel = MatchViewModel(matchModel: match)
        viewModel.numberOfServicePlayerOne = 0
        viewModel.numberOfServicePlayerTwo = 2
        viewModel.onServe()
        
        #expect(viewModel.numberOfServicePlayerOne == 1)
        #expect(viewModel.numberOfServicePlayerTwo == 0)
    }
    
    @Test func undoLastAction() {
        let viewModel = MatchViewModel(matchModel: match)
        viewModel.onGoal(isPlayerOneScored: true)
        viewModel.undoLastAction()
        
        #expect(viewModel.pointsPlayerOne == 0)
        #expect(viewModel.pointsPlayerTwo == 0)
    }
    
    @Test func playerOneWinSet() {
        let viewModel = MatchViewModel(matchModel: match)
        viewModel.pointsPlayerOne = 10
        viewModel.pointsPlayerTwo = 5
        viewModel.onGoal(isPlayerOneScored: true)
        
        #expect(viewModel.setWinPlayerOne == 1)
        #expect(viewModel.setIsOver == true)
    }
    
    @Test func playerTwoWinSet() {
        let viewModel = MatchViewModel(matchModel: match)
        viewModel.pointsPlayerOne = 5
        viewModel.pointsPlayerTwo = 10
        viewModel.onGoal(isPlayerOneScored: false)
        
        #expect(viewModel.setWinPlayerTwo == 1)
        #expect(viewModel.setIsOver == true)
    }
    
    @Test func playerOneWinMatch() {
        let viewModel = MatchViewModel(matchModel: match)
        viewModel.setWinPlayerOne = 1
        viewModel.pointsPlayerOne = 10
        viewModel.pointsPlayerTwo = 5
        viewModel.onGoal(isPlayerOneScored: true)
        
        #expect(viewModel.matchIsOver == true, "Match should be marked as over when a player wins the required number of sets.")
    }
    
    @Test func playerTwoWinMatch() {
        let viewModel = MatchViewModel(matchModel: match)
        viewModel.setWinPlayerTwo = 1
        viewModel.pointsPlayerOne = 5
        viewModel.pointsPlayerTwo = 10
        viewModel.onGoal(isPlayerOneScored: false)
        
        #expect(viewModel.matchIsOver == true, "Match should be marked as over when a player wins the required number of sets.")
    }
    
    @Test func onGoalIfMatchisOver() {
        let viewModel = MatchViewModel(matchModel: match)
        viewModel.matchIsOver = true
        viewModel.onGoal(isPlayerOneScored: true)
        
        #expect(viewModel.pointsPlayerOne == 0)
        
    }
    
    @Test func onGoalIfSetisOver() {
        let viewModel = MatchViewModel(matchModel: match)
        viewModel.setIsOver = true
        viewModel.onGoal(isPlayerOneScored: true)
        
        #expect(viewModel.pointsPlayerOne == 0)
        
    }
}
