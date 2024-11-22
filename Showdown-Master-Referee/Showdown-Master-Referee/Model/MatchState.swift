//
//  MatchState.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 21/11/2024.
//

import Foundation

struct MatchState {
    var pointsPlayerOne: Int
    let pointsPlayerTwo: Int
    let setWinPlayerOne: Int
    let setWinPlayerTwo: Int
    var numberOfServicePlayerOne: Int
    var numberOfServicePlayerTwo: Int
    let isPlayerOneServe: Bool
    let matchIsOver: Bool
    let changeSide: Bool
}
