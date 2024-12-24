//
//  MatchViewModel.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 15/12/2024.
//

import Foundation
import SwiftUI

class MatchViewModel: ObservableObject {
    // MARK: - Match Model State
    @Published var matchModel: MatchModel?
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
    var onQuitCallback: (() -> Void)?
    
    var timer: Timer?
    
    init(matchModel: MatchModel) {
        self.matchModel = matchModel
        initializeServiceCounts()
    }
    
    // MARK: - ViewModel State
    @Published var showAlert = false
    @Published var coachShowAlert = false
    @Published var playerNameToShow: String = ""
    @Published var coachNameToShow: String = ""

    // MARK: - Match Management Methods
    func startCountdown() {
        countdownTime = 60
        self.showCountdownPopup = true
        startTimer()
    }
    
    func stopCountdown() {
        self.showCountdownPopup = false
        stopTimer()
    }
    
    private func startTimer() {
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.countdownTime > 0 {
                self.countdownTime -= 1
            } else {
                self.timer?.invalidate()
                self.showCountdownPopup = false
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    func initializeServiceCounts() {
        self.numberOfServicePlayerOne = matchModel?.playerOneFirstServe ?? true ? 1 : 0
        self.numberOfServicePlayerTwo = matchModel?.playerOneFirstServe ?? true ? 0 : 1
    }
    
    func onGoal(isPlayerOneScored: Bool) {
        if matchIsOver { return }
        if setIsOver { return }
        
        saveCurrentState(isWarning: false)
        
        if isPlayerOneScored {
            pointsPlayerOne += 2
        } else {
            pointsPlayerTwo += 2
        }
        
        let maxPoints = matchModel?.numberOfPoints ?? 11
        let pointsDifference = abs(pointsPlayerOne - pointsPlayerTwo)
        let isLastSet = (setWinPlayerOne + setWinPlayerTwo + 1) == (matchModel?.numberOfSet ?? 3)
        let requiredSetsToWin = (matchModel?.numberOfSet ?? 3) / 2 + 1
        
        if (pointsPlayerOne >= maxPoints || pointsPlayerTwo >= maxPoints) && pointsDifference >= 2 {
            if pointsPlayerOne > pointsPlayerTwo {
                setWinPlayerOne += 1
            } else {
                setWinPlayerTwo += 1
            }
            
            if setWinPlayerOne == requiredSetsToWin || setWinPlayerTwo == requiredSetsToWin {
                matchIsOver = true
                return
            } else {
                setIsOver.toggle()
                startCountdown()
            }
        }
        
        if isLastSet {
            let totalPoints: Int
            
            if isPlayerOneScored {
                totalPoints = pointsPlayerOne
            } else {
                totalPoints = pointsPlayerTwo
            }
            
            if !changeSide {
                if totalPoints >= ((maxPoints / 2) + 1) {
                    startCountdown()
                    changeSide.toggle()
                }
            } else {
                return
            }
        }
    }
    
    func onFault(isPlayerOneFault: Bool) {
        if matchIsOver { return }
        if setIsOver { return }
        
        saveCurrentState(isWarning: false)
        
        if isPlayerOneFault {
            pointsPlayerTwo += 1
        } else {
            pointsPlayerOne += 1
        }
        
        let maxPoints = matchModel?.numberOfPoints ?? 11
        let pointsDifference = abs(pointsPlayerOne - pointsPlayerTwo)
        let isLastSet = (setWinPlayerOne + setWinPlayerTwo + 1) == (matchModel?.numberOfSet ?? 3)
        let requiredSetsToWin = (matchModel?.numberOfSet ?? 3) / 2 + 1
        
        if (pointsPlayerOne >= maxPoints || pointsPlayerTwo >= maxPoints) && pointsDifference >= 2 {
            if pointsPlayerOne > pointsPlayerTwo {
                setWinPlayerOne += 1
            } else {
                setWinPlayerTwo += 1
            }
            
            if setWinPlayerOne == requiredSetsToWin || setWinPlayerTwo == requiredSetsToWin {
                matchIsOver = true
                return
            } else {
                setIsOver.toggle()
                startCountdown()
            }
        }
        
        if isLastSet {
            let totalPoints: Int
            
            if isPlayerOneFault {
                totalPoints = pointsPlayerTwo
            } else {
                totalPoints = pointsPlayerOne
            }
            
            if totalPoints >= ((maxPoints / 2) + 1) {
                startCountdown()
                changeSide.toggle()
            }
        }
    }
    
    func onServe() {
        if matchIsOver { return }
        
        saveCurrentState(isWarning: false)
        
        if numberOfServicePlayerOne > 0 {
            if numberOfServicePlayerOne == matchModel?.numberOfService ?? 2 {
                numberOfServicePlayerOne = 0
                numberOfServicePlayerTwo += 1
            } else {
                numberOfServicePlayerOne += 1
            }
        } else if numberOfServicePlayerTwo > 0 {
            if numberOfServicePlayerTwo == matchModel?.numberOfService ?? 2 {
                numberOfServicePlayerOne += 1
                numberOfServicePlayerTwo = 0
            } else {
                numberOfServicePlayerTwo += 1
            }
        }
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
    
    func saveCurrentState(isWarning: Bool) {
        if !isWarning {
            let currentState = MatchState(
                pointsPlayerOne: pointsPlayerOne,
                pointsPlayerTwo: pointsPlayerTwo,
                setWinPlayerOne: setWinPlayerOne,
                setWinPlayerTwo: setWinPlayerTwo,
                numberOfServicePlayerOne: numberOfServicePlayerOne,
                numberOfServicePlayerTwo: numberOfServicePlayerTwo,
                isPlayerOneServe: isPlayerOneServe,
                matchIsOver: matchIsOver,
                changeSide: changeSide
            )
            matchStates.append(currentState)
        } else {
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
                warningMessage: nil
            )
            matchStates.append(currentState)
        }
    }
    
    func resetMatchData() {
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
    
    func resetSet() {
        if !setIsOver { return }
        
        pointsPlayerOne = 0
        pointsPlayerTwo = 0
        matchModel?.playerOneFirstServe.toggle()
        self.numberOfServicePlayerOne = matchModel?.playerOneFirstServe ?? true ? 1 : 0
        self.numberOfServicePlayerTwo = matchModel?.playerOneFirstServe ?? true ? 0 : 1
        setIsOver.toggle()
    }
    
    func dismissMatchResult() {
        resetMatchData()
    }
    
    func showWarning(isPlayerOne: Bool) {
        if isPlayerOne {
            saveCurrentState(isWarning: true)
            isPlayerOneWarning = true
            warningShowName = matchModel?.playerOne ?? "Player One"
        } else {
            saveCurrentState(isWarning: true)
            isPlayerOneWarning = false
            warningShowName = matchModel?.playerTwo ?? "Player Two"
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
}
