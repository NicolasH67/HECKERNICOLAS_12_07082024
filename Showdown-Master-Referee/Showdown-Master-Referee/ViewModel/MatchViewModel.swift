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
    @Published var countdownTime = 0
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

    // MARK: - Internal Properties
    var onQuitCallback: (() -> Void)?
    var matchResult: [Int] = []
    var timer: Timer?

    // MARK: - Initializer
    init(matchModel: MatchModel) {
        self.matchModel = matchModel
        initializeServiceCounts()
    }

    // MARK: - Private Methods
    private func startCountdown() {
        countdownTime = 60
        self.showCountdownPopup = true
        startTimer()
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

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

    private func updateScore(isPlayerOne: Bool, points: Int) {
        if isPlayerOne {
            pointsPlayerOne += points
        } else {
            pointsPlayerTwo += points
        }
    }

    private func isSetOver() -> Bool {
        let maxPoints = matchModel.numberOfPoints
        let pointsDifference = abs(pointsPlayerOne - pointsPlayerTwo)
        return (pointsPlayerOne >= maxPoints || pointsPlayerTwo >= maxPoints) && pointsDifference >= 2
    }

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

    private func handleChangeSide(totalPoints: Int) {
        let maxPoints = matchModel.numberOfPoints
        if changeSide == false && totalPoints >= ((maxPoints / 2) + 1) {
            changeSide = true
            startCountdown()
        }
    }

    private func checkSetEndCondition(isPlayerOneScored: Bool) {
        if (setWinPlayerOne + setWinPlayerTwo + 1) == matchModel.numberOfSet {
            let totalPoints = isPlayerOneScored ? pointsPlayerOne : pointsPlayerTwo
            handleChangeSide(totalPoints: totalPoints)
        }

        if isSetOver() {
            updateSetState()
        }
    }

    private func updateMatchState(isPlayerOne: Bool, points: Int) {
        if matchIsOver || setIsOver { return }
        saveCurrentState()
        updateScore(isPlayerOne: isPlayerOne, points: points)
        checkSetEndCondition(isPlayerOneScored: isPlayerOne)
    }

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
            warningMessage: warningMessage
        )
        matchStates.append(currentState)
    }

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

    private func updateMatchResult() {
        guard let tournamentId = matchModel.tournamentId,
              let matchId = matchModel.matchId,
              let refereePassword = matchModel.refereePassword else {
            alertMessageNetwork = "Missing required data for network match."
            showAlertNetwork = true
            return
        }

        NetworkManager.shared.updateMatchResult(
            tournamentId: tournamentId,
            matchId: matchId,
            results: matchResult,
            refereePassword: refereePassword
        ) { [weak self] error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let error = error {
                    self.alertMessageNetwork = "Failed to update match result: \(error)"
                } else {
                    self.alertMessageNetwork = "Match results updated successfully!"
                }
                self.showAlertNetwork = true
            }
        }
    }
    
    // MARK: - Public Methods
    
    func initializeServiceCounts() {
        self.numberOfServicePlayerOne = matchModel.playerOneFirstServe ? 1 : 0
        self.numberOfServicePlayerTwo = matchModel.playerOneFirstServe ? 0 : 1
    }
    
    func onGoal(isPlayerOneScored: Bool) {
        updateMatchState(isPlayerOne: isPlayerOneScored, points: 2)
    }

    func onFault(isPlayerOneFault: Bool) {
        updateMatchState(isPlayerOne: !isPlayerOneFault, points: 1)
    }

    func onServe() {
        if matchIsOver || setIsOver { return }
        saveCurrentState()
        updateServiceCounts(isPlayerOne: numberOfServicePlayerOne > 0)
    }

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
    }

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

    func dismissWarning() {
        showWarningPopup = false
    }

    func onWarning(isPlayerOneWarning: Bool) {
        if selectedWarning == "Warning" {
            showWarningPopup = false
            return
        } else if  selectedWarning == "Penalty" || selectedWarning == "Penalty (Glasses)" {
            onGoal(isPlayerOneScored: !isPlayerOneWarning)
            showWarningPopup = false
        }
    }
    
    func stopCountdown() {
        self.showCountdownPopup = false
        stopTimer()
    }

    // MARK: - ViewModel Actions
    func onPlayerTap(player: String, coach: String) {
        playerNameToShow = player
        coachNameToShow = coach
        coachShowAlert = true
    }

    func onCancelLastAction() {
        undoLastAction()
        undoLastAction()
    }

    func onStartChrono() {
        startCountdown()
    }

    func onEndOfSet() {
        resetSet()
    }

    func onQuitMatch() {
        if matchIsOver {
            if let onQuit = onQuitCallback {
                onQuit()
            }
        } else {
            showAlert = true
        }
    }

    func onConfirmQuit() {
        resetMatchData()
    }

    func onDismissCountdown() {
        stopCountdown()
    }

    func onMore5() {
        countdownTime += 5
    }

    func onMore10() {
        countdownTime += 10
    }
}
