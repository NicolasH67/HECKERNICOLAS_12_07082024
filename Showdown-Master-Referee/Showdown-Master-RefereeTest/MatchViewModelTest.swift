//
//  MatchViewModelTest.swift
//  Showdown-Master-RefereeTest
//
//  Created by Nicolas Hecker on 28/12/2024.
//

import Testing
import Foundation
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
    
    let match3 = MatchModel(
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
        isNetworkMatch: true,
        matchId: "1",
        tournamentId: "1",
        refereePassword: "referee"
    )
    
    @Test("When Player One scores a goal, their points are updated correctly")
    func whenPlayerOneScoresGoal_thenPointsAreUpdatedCorrectly() {
        let viewModel = MatchViewModel(matchModel: match1)
        
        viewModel.onGoal(isPlayerOneScored: true)
        
        #expect(viewModel.pointsPlayerOne == 2, "Player One should have 2 points after scoring a goal.")
        #expect(viewModel.pointsPlayerTwo == 0, "Player Two should have 0 points if Player One scores.")
    }
    
    @Test("When Player Two score a goal, their points are updated correclty")
    func whenPlayerTwoScoresGoal_thenPointsAreUpdatedCorrectly() {
        let viewModel = MatchViewModel(matchModel: match1)
        
        viewModel.onGoal(isPlayerOneScored: false)
        
        #expect(viewModel.pointsPlayerOne == 0, "Player One should have 0 points if Player Two scores.")
        #expect(viewModel.pointsPlayerTwo == 2, "Player Two should have 2 points after scoring a goal.")
    }
    
    @Test("When Player One commits a fault, Player Two scores a point")
    func whenPlayerOneCommitsFault_thenPlayerTwoScoresPoint() {
        let viewModel = MatchViewModel(matchModel: match1)
        
        viewModel.onFault(isPlayerOneFault: true)
        
        #expect(viewModel.pointsPlayerOne == 0, "Player One should have 0 points after committing a fault.")
        #expect(viewModel.pointsPlayerTwo == 1, "Player Two should have 1 point after Player One's fault.")
    }
    
    @Test("When Player Two commits a fault, Player One scores a point")
    func whenPlayerTwoCommitsFault_thenPlayerOneScoresPoint() {
        let viewModel = MatchViewModel(matchModel: match1)
        
        viewModel.onFault(isPlayerOneFault: false)
        
        #expect(viewModel.pointsPlayerOne == 1, "Player One should have 1 point")
        #expect(viewModel.pointsPlayerTwo == 0, "Player Two should have 0 points")
    }
    
    @Test("When Player One serves, their service count is updated correctly")
    func whenPlayerOneServes_thenServiceCountIsUpdatedCorrectly() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.numberOfServicePlayerOne = 1
        viewModel.numberOfServicePlayerTwo = 0
        
        viewModel.onServe()
        
        #expect(viewModel.numberOfServicePlayerOne == 2, "Player One's service count should be incremented to 2.")
        #expect(viewModel.numberOfServicePlayerTwo == 0, "Player Two's service count should remain at 0.")
    }

    
    @Test("When Player Two serves, their service count is updated correctly")
    func whenPlayerTwoServes_thenServiceCountIsUpdatedCorrectly() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.numberOfServicePlayerOne = 0
        viewModel.numberOfServicePlayerTwo = 1
        
        viewModel.onServe()
        
        #expect(viewModel.numberOfServicePlayerOne == 0)
        #expect(viewModel.numberOfServicePlayerTwo == 2)
    }
    
    @Test("When Player Two begins serve, the service switches correctly")
    func whenPlayerTwoBeginsServe_thenServiceSwitchesCorrectly() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.numberOfServicePlayerOne = 2
        viewModel.numberOfServicePlayerTwo = 0
        
        viewModel.onServe()
        
        #expect(viewModel.numberOfServicePlayerOne == 0, "Player One's service count should reset to 0.")
        #expect(viewModel.numberOfServicePlayerTwo == 1, "Player Two's service count should increment to 1.")
    }

    
    @Test("When Player One begins serve, the service switches correctly")
    func whenPlayerOneBeginsServe_thenServiceSwitchesCorrectly() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.numberOfServicePlayerOne = 0
        viewModel.numberOfServicePlayerTwo = 2
        
        viewModel.onServe()
        
        #expect(viewModel.numberOfServicePlayerOne == 1)
        #expect(viewModel.numberOfServicePlayerTwo == 0)
    }
    
    @Test("When undoing the last action, the state is reverted correctly")
    func whenUndoingLastAction_thenStateIsReverted() {
        let viewModel = MatchViewModel(matchModel: match1)
        
        viewModel.onGoal(isPlayerOneScored: true)
        viewModel.onServe()
        viewModel.onCancelLastAction()
        
        #expect(viewModel.pointsPlayerOne == 0, "Player One's points should revert to 0.")
        #expect(viewModel.pointsPlayerTwo == 0, "Player Two's points should remain 0.")
        #expect(viewModel.numberOfServicePlayerOne == 1, "Player One's service count should revert to 1.")
        #expect(viewModel.numberOfServicePlayerTwo == 0, "Player Two's service count should remain 0.")
    }

    
    @Test("When Player One wins a set, the set state is updated correctly")
    func whenPlayerOneWinsSet_thenSetStateIsUpdatedCorrectly() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.pointsPlayerOne = 10
        viewModel.pointsPlayerTwo = 5
        
        viewModel.onGoal(isPlayerOneScored: true)
        
        #expect(viewModel.setWinPlayerOne == 1)
        #expect(viewModel.setIsOver == true)
    }
    
    @Test("When Player Two wins a set, the set state is updated correctly")
    func whenPlayerTwoWinsSet_thenSetStateIsUpdatedCorrectly() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.pointsPlayerOne = 5
        viewModel.pointsPlayerTwo = 10
        
        viewModel.onGoal(isPlayerOneScored: false)
        
        #expect(viewModel.setWinPlayerTwo == 1)
        #expect(viewModel.setIsOver == true)
    }
    
    @Test("When Player One wins the match, the match state is updated correctly")
    func whenPlayerOneWinsMatch_thenMatchStateIsUpdatedCorrectly() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.setWinPlayerOne = 1
        viewModel.pointsPlayerOne = 10
        viewModel.pointsPlayerTwo = 5
        
        viewModel.onGoal(isPlayerOneScored: true)
        
        #expect(viewModel.matchIsOver == true, "Match should be marked as over when a player wins the required number of sets.")
    }
    
    @Test("When Player Two wins the match, the match state is updated correctly")
    func whenPlayerTwoWinsMatch_thenMatchStateIsUpdatedCorrectly() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.setWinPlayerTwo = 1
        viewModel.pointsPlayerOne = 5
        viewModel.pointsPlayerTwo = 10
        
        viewModel.onGoal(isPlayerOneScored: false)
        
        #expect(viewModel.matchIsOver == true, "Match should be marked as over when a player wins the required number of sets.")
    }
    
    @Test("When the match is over, goals are ignored")
    func whenMatchIsOver_thenGoalIsIgnored() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.matchIsOver = true
        
        viewModel.onGoal(isPlayerOneScored: true)
        
        #expect(viewModel.pointsPlayerOne == 0)
    }
    
    @Test("When the set is over, goals are ignored")
    func whenSetIsOver_thenGoalIsIgnored() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.setIsOver = true
    
        viewModel.onGoal(isPlayerOneScored: true)
        
        #expect(viewModel.pointsPlayerOne == 0)
    }
    
    @Test("When the set is over and Player One serves first, scores and service counts are reset")
    func whenSetIsOverAndPlayerOneFirstServe_thenScoresAndServiceAreReset() {
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
    
    @Test("When the set is over and Player Two serves first, scores and service counts are reset")
    func whenSetIsOverAndPlayerTwoFirstServe_thenScoresAndServiceAreReset() {
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
    
    @Test("When score is below points per set, the set is not over")
    func whenScoreIsBelowPointsPerSet_thenSetIsNotOver() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.pointsPlayerOne = 5
        viewModel.pointsPlayerTwo = 8
        
        viewModel.onGoal(isPlayerOneScored: false)
        
        #expect(viewModel.setIsOver == false)
    }
    
    @Test("When undoing the last action with score at 0-0, scores should remain unchanged and non-negative")
    func whenUndoLastAction_thenScoresAreReverted() {
        let viewModel = MatchViewModel(matchModel: match1)
        
        viewModel.undoLastAction()
        
        #expect(viewModel.pointsPlayerOne == 0)
        #expect(viewModel.pointsPlayerTwo == 0)
    }
    
    @Test("When Player Two scores with no two-point lead, the set is not over")
    func whenPlayerTwoScores_withNoTwoPointLead_thenSetIsNotOver() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.pointsPlayerOne = 10
        viewModel.pointsPlayerTwo = 9
        
        viewModel.onGoal(isPlayerOneScored: false)
        
        #expect(viewModel.setIsOver == false)
    }
    
    @Test("When Player One score with no two-point lead, the set is not over")
    func whenPlayerOneScores_withNoTwoPointLead_thenSetIsNotOver() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.pointsPlayerOne = 9
        viewModel.pointsPlayerTwo = 10
        
        viewModel.onGoal(isPlayerOneScored: true)
        
        #expect(viewModel.setIsOver == false)
    }
    
    @Test("When Player Two scores with no two-point lead in the final set, the match is not over")
    func whenPlayerTwoScores_withNoTwoPointLeadInFinalSet_thenMatchIsNotOver() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.setWinPlayerOne = 1
        viewModel.setWinPlayerTwo = 1
        viewModel.pointsPlayerOne = 10
        viewModel.pointsPlayerTwo = 9
        
        viewModel.onGoal(isPlayerOneScored: false)
        
        #expect(viewModel.matchIsOver == false)
    }
    
    @Test("When Player One scores with no two-point lead in the final set, the match is not over")
    func whenPlayerOneScores_withNoTwoPointLeadInFinalSet_thenMatchIsNotOver() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.setWinPlayerOne = 1
        viewModel.setWinPlayerTwo = 1
        viewModel.pointsPlayerOne = 9
        viewModel.pointsPlayerTwo = 10
        
        viewModel.onGoal(isPlayerOneScored: true)
        
        #expect(viewModel.matchIsOver == false)
    }
    
    @Test("When Player One scores without reaching halfway points, the side should change")
    func whenPlayerOneScores_withoutReachingHalfwayPoints_thenChangeSide() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.setWinPlayerOne = 1
        viewModel.setWinPlayerTwo = 1
        viewModel.pointsPlayerOne = 4
        
        viewModel.onGoal(isPlayerOneScored: true)
        
        #expect(viewModel.changeSide == true)
    }
    
    @Test("When match is over, onServe does not change service count")
    func whenMatchIsOver_doesNotChangeServiceCount() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.numberOfServicePlayerOne = 1
        viewModel.numberOfServicePlayerTwo = 0
        viewModel.matchIsOver = true
        
        viewModel.onServe()
        
        #expect(viewModel.numberOfServicePlayerOne == 1)
        #expect(viewModel.numberOfServicePlayerTwo == 0)
    }
    
    @Test("When scores are tied, onEndOfSet does not reset points")
    func whenScoresAreTied_doesNotResetPoints() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.pointsPlayerOne = 10
        viewModel.pointsPlayerTwo = 10
        
        viewModel.onEndOfSet()
        
        #expect(viewModel.pointsPlayerOne == 10)
        #expect(viewModel.pointsPlayerTwo == 10)
    }
    
    @Test("When scores are tied, onEndOfSet does not reset points")
    func whenConfirmQuit_resetsMatchState() {
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
    
    @Test("When quitting a match, an alert should be displayed")
    func whenQuitMatch_displaysAlert() {
        let viewModel = MatchViewModel(matchModel: match1)
        
        viewModel.onQuitMatch()
        
        #expect(viewModel.showAlert == true)
    }
    
    @Test("When starting the countdown, it initializes the countdown time and displays the popup")
    func whenStartCountdown_initializesCountdownTime() {
        let viewModel = MatchViewModel(matchModel: match1)
        
        viewModel.onStartChrono()
        
        #expect(viewModel.countdownTime == 60)
        #expect(viewModel.showCountdownPopup == true)
        #expect(viewModel.timer != nil)
    }
    
    @Test("When stopping the timer, it resets the timer and hides the countdown popup")
    func whenStopTimer_resetsTimer() {
        let viewModel = MatchViewModel(matchModel: match1)
        
        viewModel.onStartChrono()
        viewModel.onDismissCountdown()
        
        #expect(viewModel.showCountdownPopup == false)
        #expect(viewModel.timer == nil)
    }
    
    @Test("When adding 5 seconds, countdown time increases by 5")
    func whenOnMore5_increasesCountdownTimeBy5() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.countdownTime = 10
        
        viewModel.onMore5()
        
        #expect(viewModel.countdownTime == 15)
    }
    
    @Test("When adding 10 seconds, countdown time inscreases by 10")
    func whenOnMore10_increasesCountdownTimeBy10() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.countdownTime = 10
        
        viewModel.onMore10()
     
        #expect(viewModel.countdownTime == 20)
    }
    
    @Test("When player is tapped, it updates player and coach info and displays alert")
    func whenPlayerTap_updatesPlayerAndCoachInfoAndShowsAlert() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.onPlayerTap(player: "Player One", coach: "Coach One")
        
        #expect(viewModel.playerNameToShow == "Player One")
        #expect(viewModel.coachNameToShow == "Coach One")
        #expect(viewModel.coachShowAlert == true)
    }
    
    @Test("When onStartChrono is called, it starts the timer")
    func whenOnStartChrono_startsTimer() {
        let viewModel = MatchViewModel(matchModel: match1)
        
        viewModel.onStartChrono()
        viewModel.onStartChrono()
        
        #expect(viewModel.timer != nil)
    }
    
    @Test("When warning is shown for Player One, correct warning popup is displayed")
    func whenShowWarningForPlayerOne_displaysCorrectWarningPopup() {
        let viewModel = MatchViewModel(matchModel: match1)
        
        viewModel.showWarning(isPlayerOne: true)
        
        #expect(viewModel.isPlayerOneWarning == true)
        #expect(viewModel.warningShowName == "Player One")
        #expect(viewModel.showWarningPopup == true)
    }
    
    @Test("When warning is shown for Player Two, correct warning popup is displayed")
    func whenShowWarningForPlayerTwo_displaysCorrectWarningPopup() {
        let viewModel = MatchViewModel(matchModel: match1)
        
        viewModel.showWarning(isPlayerOne: false)
        
        #expect(viewModel.isPlayerOneWarning == false)
        #expect(viewModel.warningShowName == "Player Two")
        #expect(viewModel.showWarningPopup == true)
    }
    
    @Test("When dismissWarning is called, the warning popup is hidden")
    func whenDismissWarning_hidesWarningPopup() {
        let viewModel = MatchViewModel(matchModel: match1)
        
        viewModel.showWarning(isPlayerOne: true)
        viewModel.dismissWarning()
        
        #expect(viewModel.showWarningPopup == false)
    }
    
    @Test("When a warning is selected, the points should not change for the warning")
    func whenWarningWithSelectedWarning_doesNotChangePointsForWarning() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.selectedWarning = "Warning"
        
        viewModel.onWarning(isPlayerOneWarning: true)
        
        #expect(viewModel.pointsPlayerOne == 0)
        #expect(viewModel.pointsPlayerTwo == 0)
    }
    
    @Test("When a penalty is selected, points should be updated for the penalty")
    func whenWarningWithSelectedPenalty_updatesPointsForPenalty() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.selectedWarning = "Penalty"
        
        viewModel.onWarning(isPlayerOneWarning: true)
        
        #expect(viewModel.pointsPlayerOne == 0)
        #expect(viewModel.pointsPlayerTwo == 2)
    }
    
    @Test("When a penalty for glasses is selected, points should be updated for the penalty")
    func whenWarningWithSelectedPenaltyGlasses_updatesPointsForPenaltyGlasses() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.selectedWarning = "Penalty (Glasses)"
        
        viewModel.onWarning(isPlayerOneWarning: true)
        
        #expect(viewModel.pointsPlayerOne == 0)
        #expect(viewModel.pointsPlayerTwo == 2)
    }
    
    @Test("When a warning is applied to Player Two, points should not change")
    func whenWarningForPlayerTwo_doesNotChangePointsForWarning() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.selectedWarning = "Warning"
        
        viewModel.onWarning(isPlayerOneWarning: false)
        
        #expect(viewModel.pointsPlayerOne == 0)
        #expect(viewModel.pointsPlayerTwo == 0)
    }
    
    @Test("When a penalty is selected, points should be updated for the penalty")
    func whenWarningWithSelectedPenaltyForPlayerTwo_updatesPointsForPenalty() {
        let viewModel = MatchViewModel(matchModel: match1)
        
        viewModel.selectedWarning = "Penalty"
        viewModel.onWarning(isPlayerOneWarning: false)
        #expect(viewModel.pointsPlayerOne == 2)
        #expect(viewModel.pointsPlayerTwo == 0)
    }
    
    @Test("When Player Two receives a penalty for glasses, points should be updated accordingly")
    func whenWarningForPlayerTwoWithPenaltyGlasses_updatesPointsForPenaltyGlasses() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.selectedWarning = "Penalty (Glasses)"
        viewModel.onWarning(isPlayerOneWarning: false)
        #expect(viewModel.pointsPlayerOne == 2)
        #expect(viewModel.pointsPlayerTwo == 0)
    }
    
    @Test func whenGoalIsScored_updateMatchStateAndTriggerNetworkRequest() async throws {
        let mockNetworkManager = MockNetworkManager(networkService: MockNetworkService())
        let viewModel = MatchViewModel(matchModel: match3, networkManager: mockNetworkManager)

        viewModel.pointsPlayerOne = 10
        viewModel.pointsPlayerTwo = 8
        viewModel.setWinPlayerOne = 1
        viewModel.setWinPlayerTwo = 0
        
        mockNetworkManager.fetchMatchResult = .success(Match(id: 1, player_one: "Player One", player_two: "Player Two", referee_password: "Password", match_id: 1, tournament_id: 1, result: [11,8]))

        viewModel.onGoal(isPlayerOneScored: true)
        
        try await Task.sleep(for: .seconds(1))

        #expect(viewModel.setWinPlayerOne == 2)
        #expect(viewModel.matchIsOver == true)
        #expect(mockNetworkManager.fetchMatchResult != nil)
    }
    
//    @Test func whenGoalIsScored_updateMatchStateAndTriggerNetworkRequestError() async throws {
//        let mockNetworkManager = MockNetworkManager(networkService: MockNetworkService())
//        let viewModel = MatchViewModel(matchModel: match3, networkManager: mockNetworkManager)
//
//        viewModel.pointsPlayerOne = 10
//        viewModel.pointsPlayerTwo = 8
//        viewModel.setWinPlayerOne = 1
//        viewModel.setWinPlayerTwo = 0
//
//        viewModel.onGoal(isPlayerOneScored: true)
//        mockNetworkManager.fetchMatchResult = .failure(NetworkError.custom("error"))
//        
//        try await Task.sleep(for: .seconds(1))
//
//        #expect(viewModel.setWinPlayerOne == 2)
//        #expect(viewModel.matchIsOver == true)
//        #expect(viewModel.alertMessageNetwork == "error")
//    }
    
    @Test("When countdown reaches zero, countdownTime should be reset")
    func whenCountdownReachesZero_countdownTimeShouldBeReset() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.countdownTime = 2
        
        viewModel.onStartChrono()
        
        let start = Date()
        while Date().timeIntervalSince(start) < 2 {
            RunLoop.current.run(until: Date() + 0.1)
        }
        
        #expect(viewModel.countdownTime == 0)
    }
    
    @Test("When timeout is reached, countdownTime should reset to initial value")
    func whenTimeoutIsReached_countdownTimeShouldResetToInitialValue() {
        let viewModel = MatchViewModel(matchModel: match1)
        viewModel.countdownTime = 2
        
        viewModel.onStartChrono()
        
        let start = Date()
        while Date().timeIntervalSince(start) < 3 {
            RunLoop.current.run(until: Date() + 0.1)
        }
        
        #expect(viewModel.countdownTime == 60)
    }
    
    @Test("When match is over, onQuitMatch should trigger quit callback")
    func whenMatchIsOver_onQuitMatchShouldTriggerQuitCallback() {
        let viewModel = MatchViewModel(matchModel: match1)
        var isQuitCalled = false
        
        viewModel.onQuitCallback = {
            isQuitCalled = true
        }
        
        viewModel.matchIsOver = true
        
        viewModel.onQuitMatch()
        
        #expect(isQuitCalled)
    }
}
