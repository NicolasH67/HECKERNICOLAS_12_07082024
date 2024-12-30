//
//  NetworkManager.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 22/11/2024.
//

import Alamofire
import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    private let baseUrl = "https://wpjudvkeaiohzmijckyl.supabase.co/rest/v1"
    private let apiKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndwanVkdmtlYWlvaHptaWpja3lsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzIyODE3NzYsImV4cCI6MjA0Nzg1Nzc3Nn0.y7CBBrm8jNydpgEE2L6m6KRu1ilCq_I0O5HmjHBwRIM"

    func fetchMatch(tournamentId: String, matchId: String, refereePassword: String, completion: @escaping (Match?, String?) -> Void) {
        guard !tournamentId.isEmpty else {
            completion(nil, "Tournament ID cannot be empty.")
            return
        }
        
        guard !matchId.isEmpty else {
            completion(nil, "Match ID cannot be empty.")
            return
        }
        guard !refereePassword.isEmpty else {
            completion(nil, "Referee Password cannot be empty.")
            return
        }
        
        let url = "\(baseUrl)/matchs?tournament_id=eq.\(tournamentId)&match_id=eq.\(matchId)&apikey=\(apiKey)"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(apiKey)",
            "apikey": apiKey,
            "Content-Type": "application/json"
        ]
        
        AF.request(url, headers: headers).responseDecodable(of: [Match].self) { response in
            switch response.result {
            case .success(let matches):
                guard let match = matches.first else {
                    completion(nil, "No matches found for tournament ID \(tournamentId).")
                    return
                }
                
                if match.referee_password == refereePassword {
                    completion(match, nil)
                    return
                } else {
                    completion(nil, "Wrong password")
                    return
                }
            case .failure(let error):
                completion(nil, "Network Error: \(error.localizedDescription)")
                return
            }
        }
    }
    
    func updateMatchResult(tournamentId: String, matchId: String, results: [Int], refereePassword: String, completion: @escaping (String?) -> Void) {
            guard !tournamentId.isEmpty else {
                completion("Tournament ID cannot be empty.")
                return
            }

            guard !matchId.isEmpty else {
                completion("Match ID cannot be empty.")
                return
            }

            guard !results.isEmpty else {
                completion("Results cannot be empty.")
                return
            }

            guard !refereePassword.isEmpty else {
                completion("Referee Password cannot be empty.")
                return
            }

            let url = "\(baseUrl)/matchs?match_id=eq.\(matchId)&tournament_id=eq.\(tournamentId)"

            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(apiKey)",
                "apikey": apiKey,
                "Content-Type": "application/json"
            ]

            let parameters: [String: Any] = [
                "result": results,
                "referee_password": refereePassword
            ]

            AF.request(url, method: .patch, parameters: parameters, encoding: JSONEncoding.default, headers: headers).response { response in
                switch response.result {
                case .success:
                    if let statusCode = response.response?.statusCode, statusCode == 204 {
                        completion(nil) // Success, no content returned
                    } else {
                        completion("Unexpected response from server.")
                    }
                case .failure(let error):
                    completion("Network Error: \(error.localizedDescription)")
                }
            }
        }
}
