//
//  MatchService.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 15/12/2024.
//

import Foundation

class MatchService {
    var matchModel: MatchModel?

    func calculateNextState(
        currentPointsPlayerOne: Int,
        currentPointsPlayerTwo: Int,
        isPlayerOneScored: Bool
    ) -> (pointsPlayerOne: Int, pointsPlayerTwo: Int, setWonPlayerOne: Bool) {
        let maxPoints = matchModel?.numberOfPoints ?? 11
        var pointsPlayerOne = currentPointsPlayerOne
        var pointsPlayerTwo = currentPointsPlayerTwo
        
        if isPlayerOneScored {
            pointsPlayerOne += 1
        } else {
            pointsPlayerTwo += 1
        }
        
        // Calcul des conditions de victoire d'un set
        if pointsPlayerOne >= maxPoints && pointsPlayerOne - pointsPlayerTwo >= 2 {
            return (pointsPlayerOne, pointsPlayerTwo, true)
        }
        if pointsPlayerTwo >= maxPoints && pointsPlayerTwo - pointsPlayerOne >= 2 {
            return (pointsPlayerOne, pointsPlayerTwo, false)
        }
        
        return (pointsPlayerOne, pointsPlayerTwo, false)
    }
}
