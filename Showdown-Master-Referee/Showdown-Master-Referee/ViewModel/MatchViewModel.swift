//
//  MatchViewModel.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 15/12/2024.
//

import Foundation
import SwiftUI

class MatchViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var matchModel: MatchModel
    @Published var matchStates: [MatchState] = []
    @Published var pointsPlayerOne = 0
    @Published var pointsPlayerTwo = 0
    @Published var setWinPlayerOne = 0
    @Published var setWinPlayerTwo = 0
    @Published var numberOfServicePlayerOne = 0
    @Published var numberOfServicePlayerTwo = 0
    @Published var timeOutButtonIsDisabledPlayerOne = false
    @Published var timeOutButtonIsDisabledPlayerTwo = false
    @Published var matchIsOver = false
    @Published var setIsOver = false
    @Published var showCountdownPopup = false
    @Published var showWarningPopup = false
    @Published var countdownTime = 60
    @Published var showMatchResultPopup = false
    @Published var changeSide = false
    @Published var isPlayerOneServe = true
    @Published var isPlayerOneWarning = false
    @Published var selectedWarning: String? = nil
    @Published var warningShowName: String = ""
    @Published var alertMessageNetwork: String = ""
    @Published var showAlertNetwork: Bool = false
    @Published var showAlert = false
    @Published var coachShowAlert = false
    @Published var playerNameToShow: String = ""
    @Published var coachNameToShow: String = ""
    var networkManager: NetworkManager?

    // MARK: - Properties
    
    var onQuitCallback: (() -> Void)?
    var matchResult: [Int] = []
    var timer: Timer?

    // MARK: - Initializer
    
    init(matchModel: MatchModel, networkManager: NetworkManager? = nil) {
        self.matchModel = matchModel
        self.networkManager = networkManager
        initializeServiceCounts()
    }

    // MARK: - Private Methods
    
    /// Starts the countdown by displaying the countdown popup and initializing the timer.
    private func startCountdown() {
        saveCurrentState()
        saveCurrentState()
        self.showCountdownPopup = true
        startTimer()
    }

    /// Stops the timer and resets the countdown time.
    private func stopTimer() {
        countdownTime = 60
        timer?.invalidate()
        timer = nil
    }

    /// Starts a timer that updates the countdown time every second.
    private func startTimer() {
        guard timer == nil else { return }

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            if self.countdownTime > 0 {
                self.countdownTime -= 1
            } else {
                self.stopTimer()
                self.showCountdownPopup = false
            }
        }
    }

    /// Updates the score of the players based on who scored and the points added.
    private func updateScore(isPlayerOne: Bool, points: Int) {
        if isPlayerOne {
            pointsPlayerOne += points
        } else {
            pointsPlayerTwo += points
        }
    }

    /// Checks if a set is over based on the points scored and the required margin.
    private func isSetOver() -> Bool {
        let maxPoints = matchModel.numberOfPoints
        let pointsDifference = abs(pointsPlayerOne - pointsPlayerTwo)
        return (pointsPlayerOne >= maxPoints || pointsPlayerTwo >= maxPoints) && pointsDifference >= 2
    }

    /// Updates the set state based on the scores and checks if the match is over.
    private func updateSetState() {
        if pointsPlayerOne > pointsPlayerTwo {
            setWinPlayerOne += 1
        } else {
            setWinPlayerTwo += 1
        }

        let requiredSetsToWin = (matchModel.numberOfSet) / 2 + 1

        if setWinPlayerOne == requiredSetsToWin || setWinPlayerTwo == requiredSetsToWin {
            matchIsOver = true
            matchResult.append(pointsPlayerOne)
            matchResult.append(pointsPlayerTwo)

            if matchModel.isNetworkMatch {
                updateMatchResult()
            }
        } else {
            setIsOver = true
            startCountdown()
        }
    }

    /// Handles the side change based on the total points scored and the match conditions.
    private func handleChangeSide(totalPoints: Int) {
        let maxPoints = matchModel.numberOfPoints
        if changeSide == false && totalPoints >= ((maxPoints / 2) + 1) {
            changeSide = true
            startCountdown()
        }
    }

    /// Checks the set-end condition and updates the match state accordingly.
    private func checkSetEndCondition(isPlayerOneScored: Bool) {
        if (setWinPlayerOne + setWinPlayerTwo + 1) == matchModel.numberOfSet {
            let totalPoints = isPlayerOneScored ? pointsPlayerOne : pointsPlayerTwo
            handleChangeSide(totalPoints: totalPoints)
        }

        if isSetOver() {
            updateSetState()
        }
    }

    /// Updates the match state by saving the current state and checking the set-end condition.
    private func updateMatchState(isPlayerOne: Bool, points: Int) {
        if matchIsOver || setIsOver { return }
        saveCurrentState()
        updateScore(isPlayerOne: isPlayerOne, points: points)
        checkSetEndCondition(isPlayerOneScored: isPlayerOne)
    }

    /// Updates the service count for each player based on the number of services.
    private func updateServiceCounts(isPlayerOne: Bool) {
        if isPlayerOne {
            if numberOfServicePlayerOne == matchModel.numberOfService {
                numberOfServicePlayerOne = 0
                numberOfServicePlayerTwo += 1
            } else {
                numberOfServicePlayerOne += 1
            }
        } else {
            if numberOfServicePlayerTwo == matchModel.numberOfService {
                numberOfServicePlayerOne += 1
                numberOfServicePlayerTwo = 0
            } else {
                numberOfServicePlayerTwo += 1
            }
        }
    }

    /// Saves the current match state to track progress.
    private func saveCurrentState(warningMessage: String? = nil) {
        let currentState = MatchState(
            pointsPlayerOne: pointsPlayerOne,
            pointsPlayerTwo: pointsPlayerTwo,
            setWinPlayerOne: setWinPlayerOne,
            setWinPlayerTwo: setWinPlayerTwo,
            numberOfServicePlayerOne: numberOfServicePlayerOne,
            numberOfServicePlayerTwo: numberOfServicePlayerTwo,
            isPlayerOneServe: isPlayerOneServe,
            matchIsOver: matchIsOver,
            changeSide: changeSide,
            warningMessage: warningMessage,
            timeOutPlayerOne: timeOutButtonIsDisabledPlayerOne,
            timeOutPlayerTwo: timeOutButtonIsDisabledPlayerTwo
        )
        matchStates.append(currentState)
    }

    /// Resets all match-related data to prepare for a new match.
    private func resetMatchData() {
        pointsPlayerOne = 0
        pointsPlayerTwo = 0
        setWinPlayerOne = 0
        setWinPlayerTwo = 0
        numberOfServicePlayerOne = 0
        numberOfServicePlayerTwo = 0
        timeOutButtonIsDisabledPlayerOne = false
        timeOutButtonIsDisabledPlayerTwo = false
        matchIsOver = false
        showCountdownPopup = false
        countdownTime = 0
    }

    /// Resets the set data and updates the match result for the previous set.
    private func resetSet() {
        if !setIsOver { return }

        matchResult.append(pointsPlayerOne)
        matchResult.append(pointsPlayerTwo)

        pointsPlayerOne = 0
        pointsPlayerTwo = 0
        matchModel.playerOneFirstServe.toggle()
        self.numberOfServicePlayerOne = matchModel.playerOneFirstServe ? 1 : 0
        self.numberOfServicePlayerTwo = matchModel.playerOneFirstServe ? 0 : 1
        setIsOver.toggle()
    }

    /// Updates the match result on the network with the current match data.
    private func updateMatchResult() {
        guard let tournamentId = matchModel.tournamentId,
              let matchId = matchModel.matchId,
              let refereePassword = matchModel.refereePassword else {
                alertMessageNetwork = "Missing required data for network match."
                showAlertNetwork = true
                return
            }
        
        guard let networkManagerUnwrapped = networkManager else { return }

        networkManagerUnwrapped.updateMatchResult(
            tournamentId: tournamentId,
            matchId: matchId,
            results: matchResult,
            refereePassword: refereePassword
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.alertMessageNetwork = "Match results updated successfully!"
            case .failure(let error):
                if case let NetworkError.custom(errorMessage) = error {
                    self.alertMessageNetwork = errorMessage
                }
            }
            self.showAlertNetwork = true
        }
    }
    
    // MARK: - Public Methods
    
    /// Initializes the service counts for both players based on who serves first.
    func initializeServiceCounts() {
        self.numberOfServicePlayerOne = matchModel.playerOneFirstServe ? 1 : 0
        self.numberOfServicePlayerTwo = matchModel.playerOneFirstServe ? 0 : 1
    }
    
    /// Updates the match state when a goal is scored by a player.
    func onGoal(isPlayerOneScored: Bool) {
        updateMatchState(isPlayerOne: isPlayerOneScored, points: 2)
    }

    /// Updates the match state when a fault occurs, adjusting points accordingly.
    func onFault(isPlayerOneFault: Bool) {
        updateMatchState(isPlayerOne: !isPlayerOneFault, points: 1)
    }

    /// Updates the service count for the player serving.
    func onServe() {
        if matchIsOver || setIsOver { return }
        saveCurrentState()
        updateServiceCounts(isPlayerOne: numberOfServicePlayerOne > 0)
    }

    /// Undoes the last action by restoring the previous match state.
    func undoLastAction() {
        guard let lastState = matchStates.popLast() else { return }

        pointsPlayerOne = lastState.pointsPlayerOne
        pointsPlayerTwo = lastState.pointsPlayerTwo
        setWinPlayerOne = lastState.setWinPlayerOne
        setWinPlayerTwo = lastState.setWinPlayerTwo
        numberOfServicePlayerOne = lastState.numberOfServicePlayerOne
        numberOfServicePlayerTwo = lastState.numberOfServicePlayerTwo
        isPlayerOneServe = lastState.isPlayerOneServe
        matchIsOver = lastState.matchIsOver
        changeSide = lastState.changeSide
        timeOutButtonIsDisabledPlayerOne = lastState.timeOutPlayerOne
        timeOutButtonIsDisabledPlayerTwo = lastState.timeOutPlayerTwo
    }

    /// Displays a warning popup for the player, depending on which player triggered it.
    func showWarning(isPlayerOne: Bool) {
        if isPlayerOne {
            saveCurrentState(warningMessage: nil)
            isPlayerOneWarning = true
            warningShowName = matchModel.playerOne
        } else {
            saveCurrentState(warningMessage: nil)
            isPlayerOneWarning = false
            warningShowName = matchModel.playerTwo
        }
        showWarningPopup = true
    }

    /// Dismisses the warning popup.
    func dismissWarning() {
        showWarningPopup = false
    }

    /// Handles the warning or penalty action based on the selected warning type.
    func onWarning(isPlayerOneWarning: Bool) {
        if selectedWarning == "Warning" {
            saveCurrentState()
            showWarningPopup = false
            return
        } else if  selectedWarning == "Penalty" || selectedWarning == "Penalty (Glasses)" {
            onGoal(isPlayerOneScored: !isPlayerOneWarning)
            showWarningPopup = false
        }
    }
    
    /// Stops the countdown and hides the countdown popup.
    func stopCountdown() {
        self.showCountdownPopup = false
        stopTimer()
    }

    // MARK: - ViewModel Actions
    
    /// Displays the coach alert and shows the selected player and coach names.
    func onPlayerTap(player: String, coach: String) {
        playerNameToShow = player
        coachNameToShow = coach
        coachShowAlert = true
    }

    /// Undoes the last two actions by calling `undoLastAction` twice.
    func onCancelLastAction() {
        undoLastAction()
        undoLastAction()
    }

    /// Starts the countdown timer when the chrono is started.
    func onStartChrono() {
        startCountdown()
    }

    /// Resets the current set when the set ends.
    func onEndOfSet() {
        resetSet()
    }

    /// Handles quitting the match, prompting an alert if the match is not over.
    func onQuitMatch() {
        if matchIsOver {
            if let onQuit = onQuitCallback {
                onQuit()
            }
        } else {
            showAlert = true
        }
    }

    /// Confirms the match quit action and resets match data.
    func onConfirmQuit() {
        resetMatchData()
    }

    /// Dismisses the countdown popup and stops the timer.
    func onDismissCountdown() {
        stopCountdown()
    }

    /// Adds 5 seconds to the countdown time.
    func onMore5() {
        countdownTime += 5
    }

    /// Adds 10 seconds to the countdown time.
    func onMore10() {
        countdownTime += 10
    }
}
