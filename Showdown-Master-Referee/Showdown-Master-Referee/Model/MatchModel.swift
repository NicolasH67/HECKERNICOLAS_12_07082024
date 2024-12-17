//
//  MatchModel.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 25/10/2024.
//

import Foundation

struct MatchModel: Codable {
    let playerOne: String
    let playerTwo: String
    let coachPlayerOne: String
    let coachPlayerTwo: String
    let numberOfService: Int
    let numberOfPoints: Int
    let numberOfSet: Int
    let bestOf: String
    let playerOneFirstServe: Bool
    let changeSide: Bool
}