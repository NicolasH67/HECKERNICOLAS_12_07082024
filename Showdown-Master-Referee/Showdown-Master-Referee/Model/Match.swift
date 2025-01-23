//
//  Match.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 22/11/2024.
//

import Foundation

/// Modèle représentant un match extrait de la base de données ou d'un backend, utilisé pour la gestion des données des matchs en cours.
struct Match: Decodable {
    let id: Int
    let player_one: String
    let player_two: String
    let referee_password: String
    let match_id: Int
    let tournament_id: Int
    let result: [Int]?
}
