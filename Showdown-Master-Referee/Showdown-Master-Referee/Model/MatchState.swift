//
//  MatchState.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 21/11/2024.
//

import Foundation

/// Structure représentant l'état d'un match.
struct MatchState {
    var pointsPlayerOne: Int
    let pointsPlayerTwo: Int
    let setWinPlayerOne: Int
    let setWinPlayerTwo: Int
    let numberOfServicePlayerOne: Int
    let numberOfServicePlayerTwo: Int
    let isPlayerOneServe: Bool
    let matchIsOver: Bool
    let changeSide: Bool
    let warningMessage: String?
    let timeOutPlayerOne: Bool
    let timeOutPlayerTwo: Bool
}
