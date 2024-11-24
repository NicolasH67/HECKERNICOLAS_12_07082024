//
//  Match.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 22/11/2024.
//

import Foundation

struct Match: Decodable {
    let id: Int
    let player_one: String
    let player_two: String
    let referee_password: String
    let match_id: Int
    let tournament_id: Int
    let result: [Int]?
}
