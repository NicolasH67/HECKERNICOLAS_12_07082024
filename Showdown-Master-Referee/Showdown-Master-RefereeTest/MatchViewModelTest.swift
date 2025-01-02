//
//  MatchViewModelTest.swift
//  Showdown-Master-RefereeTest
//
//  Created by Nicolas Hecker on 28/12/2024.
//

import Testing
@testable import Showdown_Master_Referee

struct MatchViewModelTest {
    let match1 = MatchModel(
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
    
    let match2 = MatchModel(
        playerOne: "Player One",
        playerTwo: "Player Two",
        coachPlayerOne: "Coach One",
        coachPlayerTwo: "Coach Two",
        numberOfService: 2,
        numberOfPoints: 11,
        numberOfSet: 3,
        bestOf: "Best of 3",
        playerOneFirstServe: false,
        changeSide: true,
        isNetworkMatch: false,
        matchId: nil,
        tournamentId: nil,
        refereePassword: nil
    )
    
    @Test func whenPlayerOneScoresGoal_thenPointsAreUpdatedCorrectly() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.onGoal(isPlayerOneScored: true)
        #expect(viewModel.pointsPlayerOne == 2, "Player One should have 2 points after scoring a goal.")
        #expect(viewModel.pointsPlayerTwo == 0, "Player Two should have 0 points if Player One scores.")
    }
    
    @Test func whenPlayerTwoScoresGoal_thenPointsAreUpdatedCorrectly() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.onGoal(isPlayerOneScored: false)
        #expect(viewModel.pointsPlayerOne == 0, "Player One should have 0 points if Player Two scores.")
        #expect(viewModel.pointsPlayerTwo == 2, "Player Two should have 2 points after scoring a goal.")
    }
    
    @Test func whenPlayerOneCommitsFault_thenPlayerTwoScoresPoint() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.onFault(isPlayerOneFault: true)
        #expect(viewModel.pointsPlayerOne == 0, "Player One should have 0 points")
        #expect(viewModel.pointsPlayerTwo == 1, "Player Two should have 1 point")
    }
    
    @Test func whenPlayerTwoCommitsFault_thenPlayerOneScoresPoint() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.onFault(isPlayerOneFault: false)
        #expect(viewModel.pointsPlayerOne == 1, "Player One should have 1 point")
        #expect(viewModel.pointsPlayerTwo == 0, "Player Two should have 0 points")
    }
    
    @Test func whenPlayerOneServes_thenServiceCountIsUpdatedCorrectly() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.numberOfServicePlayerOne = 1
        viewModel.numberOfServicePlayerTwo = 0
        viewModel.onServe()
        #expect(viewModel.numberOfServicePlayerOne == 2)
        #expect(viewModel.numberOfServicePlayerTwo == 0)
    }
    
    @Test func whenPlayerTwoServes_thenServiceCountIsUpdatedCorrectly() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.numberOfServicePlayerOne = 0
        viewModel.numberOfServicePlayerTwo = 1
        viewModel.onServe()
        #expect(viewModel.numberOfServicePlayerOne == 0)
        #expect(viewModel.numberOfServicePlayerTwo == 2)
    }
    
    @Test func whenPlayerTwoBeginsServe_thenServiceSwitchesCorrectly() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.numberOfServicePlayerOne = 2
        viewModel.numberOfServicePlayerTwo = 0
        viewModel.onServe()
        #expect(viewModel.numberOfServicePlayerOne == 0)
        #expect(viewModel.numberOfServicePlayerTwo == 1)
    }
    
    @Test func whenPlayerOneBeginsServe_thenServiceSwitchesCorrectly() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.numberOfServicePlayerOne = 0
        viewModel.numberOfServicePlayerTwo = 2
        viewModel.onServe()
        #expect(viewModel.numberOfServicePlayerOne == 1)
        #expect(viewModel.numberOfServicePlayerTwo == 0)
    }
    
    @Test func whenUndoingLastAction_thenStateIsReverted() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.onGoal(isPlayerOneScored: true)
        viewModel.onServe()
        viewModel.onCancelLastAction()
        #expect(viewModel.pointsPlayerOne == 0)
        #expect(viewModel.pointsPlayerTwo == 0)
        #expect(viewModel.numberOfServicePlayerOne == 1)
        #expect(viewModel.numberOfServicePlayerTwo == 0)
    }
    
    @Test func whenPlayerOneWinsSet_thenSetStateIsUpdatedCorrectly() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.pointsPlayerOne = 10
        viewModel.pointsPlayerTwo = 5
        viewModel.onGoal(isPlayerOneScored: true)
        #expect(viewModel.setWinPlayerOne == 1)
        #expect(viewModel.setIsOver == true)
    }
    
    @Test func whenPlayerTwoWinsSet_thenSetStateIsUpdatedCorrectly() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.pointsPlayerOne = 5
        viewModel.pointsPlayerTwo = 10
        viewModel.onGoal(isPlayerOneScored: false)
        #expect(viewModel.setWinPlayerTwo == 1)
        #expect(viewModel.setIsOver == true)
    }
    
    @Test func whenPlayerOneWinsMatch_thenMatchStateIsUpdatedCorrectly() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.setWinPlayerOne = 1
        viewModel.pointsPlayerOne = 10
        viewModel.pointsPlayerTwo = 5
        viewModel.onGoal(isPlayerOneScored: true)
        #expect(viewModel.matchIsOver == true, "Match should be marked as over when a player wins the required number of sets.")
    }
    
    @Test func whenPlayerTwoWinsMatch_thenMatchStateIsUpdatedCorrectly() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.setWinPlayerTwo = 1
        viewModel.pointsPlayerOne = 5
        viewModel.pointsPlayerTwo = 10
        viewModel.onGoal(isPlayerOneScored: false)
        #expect(viewModel.matchIsOver == true, "Match should be marked as over when a player wins the required number of sets.")
    }
    
    @Test func whenMatchIsOver_thenGoalIsIgnored() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.matchIsOver = true
        viewModel.onGoal(isPlayerOneScored: true)
        #expect(viewModel.pointsPlayerOne == 0)
    }
    
    @Test func whenSetIsOver_thenGoalIsIgnored() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.setIsOver = true
        viewModel.onGoal(isPlayerOneScored: true)
        #expect(viewModel.pointsPlayerOne == 0)
    }
    
    @Test func whenSetIsOverAndPlayerOneFirstServe_thenScoresAndServiceAreReset() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.pointsPlayerOne = 5
        viewModel.pointsPlayerTwo = 11
        viewModel.setIsOver = true
        viewModel.onEndOfSet()
        #expect(viewModel.pointsPlayerOne == 0)
        #expect(viewModel.pointsPlayerOne == 0)
        #expect(viewModel.numberOfServicePlayerOne == 0)
        #expect(viewModel.numberOfServicePlayerTwo == 1)
    }
    
    @Test func whenSetIsOverAndPlayerTwoFirstServe_thenScoresAndServiceAreReset() {
        let viewModel = MatchViewModel(matchModel: match2)
        viewModel.pointsPlayerOne = 5
        viewModel.pointsPlayerTwo = 11
        viewModel.setIsOver = true
        viewModel.onEndOfSet()
        #expect(viewModel.pointsPlayerOne == 0)
        #expect(viewModel.pointsPlayerOne == 0)
        #expect(viewModel.numberOfServicePlayerOne == 1)
        #expect(viewModel.numberOfServicePlayerTwo == 0)
    }
    
    @Test func whenScoreDifferenceIsLessThanTwo_thenSetIsNotOver() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.pointsPlayerOne = 5
        viewModel.pointsPlayerTwo = 8
        viewModel.onGoal(isPlayerOneScored: false)
        #expect(viewModel.setIsOver == false)
    }
    
    @Test func whenUndoLastAction_thenScoresAreReverted() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.undoLastAction()
        
        #expect(viewModel.pointsPlayerOne == 0)
        #expect(viewModel.pointsPlayerTwo == 0)
    }
    
    @Test func whenPlayerTwoScores_withNoTwoPointLead_thenSetIsNotOver() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.pointsPlayerOne = 10
        viewModel.pointsPlayerTwo = 9
        viewModel.onGoal(isPlayerOneScored: false)
        
        #expect(viewModel.setIsOver == false)
    }
    
    @Test func whenPlayerOneScores_withNoTwoPointLead_thenSetIsNotOver() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.pointsPlayerOne = 9
        viewModel.pointsPlayerTwo = 10
        viewModel.onGoal(isPlayerOneScored: true)
        
        #expect(viewModel.setIsOver == false)
    }
    
    @Test func whenPlayerTwoScores_withNoTwoPointLeadInFinalSet_thenMatchIsNotOver() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.setWinPlayerOne = 1
        viewModel.setWinPlayerTwo = 1
        viewModel.pointsPlayerOne = 10
        viewModel.pointsPlayerTwo = 9
        viewModel.onGoal(isPlayerOneScored: false)
        
        #expect(viewModel.matchIsOver == false)
    }
    
    @Test func whenPlayerOneScores_withNoTwoPointLeadInFinalSet_thenMatchIsNotOver() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.setWinPlayerOne = 1
        viewModel.setWinPlayerTwo = 1
        viewModel.pointsPlayerOne = 9
        viewModel.pointsPlayerTwo = 10
        viewModel.onGoal(isPlayerOneScored: true)
        
        #expect(viewModel.matchIsOver == false)
    }
    
    @Test func whenPlayerOneScores_withoutReachingHalfwayPoints_thenChangeSide() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.setWinPlayerOne = 1
        viewModel.setWinPlayerTwo = 1
        viewModel.pointsPlayerOne = 4
        viewModel.onGoal(isPlayerOneScored: true)
        
        #expect(viewModel.changeSide == true)
    }
    
    @Test func onServe_whenMatchIsOver_doesNotChangeServiceCount() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.numberOfServicePlayerOne = 1
        viewModel.numberOfServicePlayerTwo = 0
        viewModel.matchIsOver = true
        viewModel.onServe()
        
        #expect(viewModel.numberOfServicePlayerOne == 1)
        #expect(viewModel.numberOfServicePlayerTwo == 0)
    }
    
    @Test func onEndOfSet_whenScoresAreTied_doesNotResetPoints() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.pointsPlayerOne = 10
        viewModel.pointsPlayerTwo = 10
        viewModel.onEndOfSet()
        
        #expect(viewModel.pointsPlayerOne == 10)
        #expect(viewModel.pointsPlayerTwo == 10)
    }
    
    @Test func onConfirmQuit_resetsMatchState() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.pointsPlayerOne = 11
        viewModel.pointsPlayerTwo = 9
        viewModel.setWinPlayerOne = 2
        viewModel.matchIsOver = true
        
        viewModel.onConfirmQuit()
        
        #expect(viewModel.pointsPlayerOne == 0)
        #expect(viewModel.pointsPlayerTwo == 0)
        #expect(viewModel.setWinPlayerOne == 0)
        #expect(viewModel.matchIsOver == false)
        
    }
    
    @Test func quitMatch_displaysAlert() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.onQuitMatch()
        
        #expect(viewModel.showAlert == true)
    }
    
    // Demandé en session
    @Test func quitMatch_whenMatchIsOver() {
        let viewModel = MatchViewModel(matchModel: match1)
        
        viewModel.matchIsOver = true
        
        viewModel.onQuitMatch()
        
    }
    
    @Test func startCountdown_initializesCountdownTime() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.onStartChrono()
        #expect(viewModel.countdownTime == 60)
        #expect(viewModel.showCountdownPopup == true)
        #expect(viewModel.timer != nil)
    }
    
    @Test func stopTimer_resetsTimer() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.onStartChrono()
        viewModel.onDismissCountdown()
        #expect(viewModel.showCountdownPopup == false)
        #expect(viewModel.timer == nil)
    }
    
    @Test func onMore5_increasesCountdownTimeBy5() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.countdownTime = 10
        viewModel.onMore5()
        #expect(viewModel.countdownTime == 15)
    }
    
    @Test func onMore10_increasesCountdownTimeBy10() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.countdownTime = 10
        viewModel.onMore10()
        #expect(viewModel.countdownTime == 20)
    }
    
    @Test func onPlayerTap_updatesPlayerAndCoachInfoAndShowsAlert() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.onPlayerTap(player: "Player One", coach: "Coach One")
        
        #expect(viewModel.playerNameToShow == "Player One")
        #expect(viewModel.coachNameToShow == "Coach One")
        #expect(viewModel.coachShowAlert == true)
    }
    
    @Test func onStartChrono_startsTimer() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.onStartChrono()
        viewModel.onStartChrono()
        
        #expect(viewModel.timer != nil)
    }
    
    @Test func showWarningForPlayerOne_displaysCorrectWarningPopup() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.showWarning(isPlayerOne: true)
        
        #expect(viewModel.isPlayerOneWarning == true)
        #expect(viewModel.warningShowName == "Player One")
        #expect(viewModel.showWarningPopup == true)
    }
    
    @Test func showWarningForPlayerTwo_displaysCorrectWarningPopup() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.showWarning(isPlayerOne: false)
        
        #expect(viewModel.isPlayerOneWarning == false)
        #expect(viewModel.warningShowName == "Player Two")
        #expect(viewModel.showWarningPopup == true)
    }
    
    @Test func dismissWarning_hidesWarningPopup() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.showWarning(isPlayerOne: true)
        viewModel.dismissWarning()
        
        #expect(viewModel.showWarningPopup == false)
    }
    
    @Test func onWarningWithSelectedWarning_doesNotChangePointsForWarning() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.selectedWarning = "Warning"
        
        viewModel.onWarning(isPlayerOneWarning: true)
        #expect(viewModel.pointsPlayerOne == 0)
        #expect(viewModel.pointsPlayerTwo == 0)
    }
    
    @Test func onWarningWithSelectedPenalty_updatesPointsForPenalty() {
        let viewModel = MatchViewModel(matchModel: match1)
        
        viewModel.selectedWarning = "Penalty"
        viewModel.onWarning(isPlayerOneWarning: true)
        #expect(viewModel.pointsPlayerOne == 0)
        #expect(viewModel.pointsPlayerTwo == 2)
    }
    
    @Test func onWarningWithSelectedPenaltyGlasses_updatesPointsForPenaltyGlasses() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.selectedWarning = "Penalty (Glasses)"
        viewModel.onWarning(isPlayerOneWarning: true)
        #expect(viewModel.pointsPlayerOne == 0)
        #expect(viewModel.pointsPlayerTwo == 2)
    }
    
    @Test func onWarningForPlayerTwo_doesNotChangePointsForWarning() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.selectedWarning = "Warning"
        
        viewModel.onWarning(isPlayerOneWarning: false)
        #expect(viewModel.pointsPlayerOne == 0)
        #expect(viewModel.pointsPlayerTwo == 0)
    }
    
    @Test func onWarningForPlayerTwo_updatesPointsForPenalty() {
        let viewModel = MatchViewModel(matchModel: match1)
        
        viewModel.selectedWarning = "Penalty"
        viewModel.onWarning(isPlayerOneWarning: false)
        #expect(viewModel.pointsPlayerOne == 2)
        #expect(viewModel.pointsPlayerTwo == 0)
    }
    
    @Test func onWarningForPlayerTwoWithPenaltyGlasses_updatesPointsForPenaltyGlasses() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.selectedWarning = "Penalty (Glasses)"
        viewModel.onWarning(isPlayerOneWarning: false)
        #expect(viewModel.pointsPlayerOne == 2)
        #expect(viewModel.pointsPlayerTwo == 0)
    }
}
