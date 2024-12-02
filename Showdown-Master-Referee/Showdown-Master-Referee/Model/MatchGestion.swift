//
//  MatchGestion.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 21/11/2024.
//

import Foundation
import SwiftUI

class MatchGestion: ObservableObject {
    @Published var matchModel: MatchModel?
    @Published var matchStates: [MatchState] = []
    @Published var numberOfServicePlayerOne: Int = 0
    @Published var numberOfServicePlayerTwo: Int = 0
    @Published var pointsPlayerOne: Int = 0
    @Published var pointsPlayerTwo: Int = 0
    @Published var setWinPlayerOne: Int = 0
    @Published var setWinPlayerTwo: Int = 0
    @Published var isPlayerOneServe: Bool = true
    @Published var matchIsOver: Bool = false
    @Published var changeSide: Bool = false
    @Published var showCountdownPopup = false
    @Published var countdownTime = 60
    @Published var countdownTimer: Timer?
    @Published var showCountdownPupup: Bool = false
    
    func onGoal(isPlayerOneScored: Bool) {
        if matchIsOver { return }
        
        saveCurrentState()
        
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
                resetSet()
            }
        }
        
        if isLastSet {
            let totalPoints: Int
            
            if isPlayerOneScored {
                totalPoints = pointsPlayerOne
            } else {
                totalPoints = pointsPlayerTwo
            }
            
            if totalPoints % (maxPoints / 2) == 0 {
                changeSide.toggle()
            }
        }
    }
    
    func onFault(isPlayerOneFault: Bool) {
        if matchIsOver { return }
        
        saveCurrentState()

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
                resetSet()
            }
        }
        if isLastSet {
            let totalPoints = pointsPlayerOne + pointsPlayerTwo
            
            if totalPoints % (maxPoints / 2) == 0 {
                changeSide.toggle()
            }
        }
    }

    func onServe() {
        if matchIsOver { return }
        
        saveCurrentState()
        
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
    
    func initializeServiceCounts() {
        isPlayerOneServe = matchModel?.playerOneFirstServe ?? true
        numberOfServicePlayerOne = matchModel?.playerOneFirstServe ?? true ? 1 : 0
        numberOfServicePlayerTwo = matchModel?.playerOneFirstServe ?? true ? 0 : 1
    }
    
    func resetSet() {
        isPlayerOneServe.toggle()
        
        numberOfServicePlayerOne = isPlayerOneServe ? 1 : 0
        numberOfServicePlayerTwo = isPlayerOneServe ? 0 : 1
        
        pointsPlayerOne = 0
        pointsPlayerTwo = 0
        
        startCountdown()
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
    
    func saveCurrentState() {
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
    }
    
    func startCountdown() {
        countdownTime = 60
        showCountdownPopup = true
        startCountdownTimer()
    }
        
    func stopCountdown() {
        countdownTimer?.invalidate()
        countdownTimer = nil
        showCountdownPopup = false
    }
    
    func startCountdownTimer() {
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if self.countdownTime > 0 {
                self.countdownTime -= 1
            } else {
                self.stopCountdown()
            }
        }
    }
    
    func resetMatchData() {
        matchModel = nil
        pointsPlayerOne = 0
        pointsPlayerTwo = 0
        setWinPlayerOne = 0
        setWinPlayerTwo = 0
        numberOfServicePlayerOne = 0
        numberOfServicePlayerTwo = 0
        matchIsOver = false
    }
}
