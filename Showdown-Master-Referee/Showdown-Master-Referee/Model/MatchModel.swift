//
//  MatchModel.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 25/10/2024.
//

import Foundation

/// Modèle représentant un match de tennis, utilisé pour la gestion des données et la communication avec le backend.
struct MatchModel: Codable, Hashable {
    let playerOne: String
    let playerTwo: String
    let coachPlayerOne: String
    let coachPlayerTwo: String
    let numberOfService: Int
    let numberOfPoints: Int
    let numberOfSet: Int
    let bestOf: String
    var playerOneFirstServe: Bool
    let changeSide: Bool
    let isNetworkMatch: Bool
    let matchId: String?
    let tournamentId: String?
    let refereePassword: String?
}

