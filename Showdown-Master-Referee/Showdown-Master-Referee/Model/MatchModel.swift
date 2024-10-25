//
//  MatchModel.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 25/10/2024.
//

import Foundation

struct MatchModel: Codable {
    let id: Int
    let playerOne: String
    let playerTwo: String
    let numberOfService: Int
    let numberOfPoints: Int
    let numberOfSet: Int
    let bestOf: String
    let playerOneFirstServe: Bool
    
}
