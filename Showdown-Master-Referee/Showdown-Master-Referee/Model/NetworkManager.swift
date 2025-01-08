//
//  NetworkManager.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 22/11/2024.
//

import Foundation
import Alamofire

protocol NetworkService {
    func fetch<T: Decodable>(from url: String, headers: HTTPHeaders, completion: @escaping (Result<T, Error>) -> Void)
    func update(url: String, parameters: [String: Any], headers: HTTPHeaders, completion: @escaping (Result<Void, Error>) -> Void)
}

class AlamofireNetworkService: NetworkService {
    func fetch<T: Decodable>(from url: String, headers: HTTPHeaders, completion: @escaping (Result<T, Error>) -> Void) {
        AF.request(url, headers: headers).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func update(url: String, parameters: [String: Any], headers: HTTPHeaders, completion: @escaping (Result<Void, Error>) -> Void) {
        AF.request(url, method: .patch, parameters: parameters, encoding: JSONEncoding.default, headers: headers).response { response in
            switch response.result {
            case .success:
                if response.response?.statusCode == 204 {
                    completion(.success(()))
                } else {
                    completion(.failure(NSError(domain: "Unexpected response", code: response.response?.statusCode ?? 0)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

enum NetworkError: Error {
    case custom(String)
}

class NetworkManager {
    private let networkService: NetworkService
    private let baseUrl = "https://wpjudvkeaiohzmijckyl.supabase.co/rest/v1"
    private let apiKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndwanVkdmtlYWlvaHptaWpja3lsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzIyODE3NzYsImV4cCI6MjA0Nzg1Nzc3Nn0.y7CBBrm8jNydpgEE2L6m6KRu1ilCq_I0O5HmjHBwRIM"

    init(networkService: NetworkService = AlamofireNetworkService()) {
        self.networkService = networkService
    }

    func fetchMatch(tournamentId: String, matchId: String, refereePassword: String, completion: @escaping (Result<Match, NetworkError>) -> Void) {
        guard !tournamentId.isEmpty else {
            completion(.failure(.custom("Tournament ID cannot be empty.")))
            return
        }
        
        guard !matchId.isEmpty else {
            completion(.failure(.custom("Match ID cannot be empty.")))
            return
        }
        
        guard !refereePassword.isEmpty else {
            completion(.failure(.custom("Referee Password cannot be empty.")))
            return
        }

        let url = "\(baseUrl)/matchs?tournament_id=eq.\(tournamentId)&match_id=eq.\(matchId)&apikey=\(apiKey)"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(apiKey)",
            "apikey": apiKey,
            "Content-Type": "application/json"
        ]

        networkService.fetch(from: url, headers: headers) { (result: Result<[Match], Error>) in
            switch result {
            case .success(let matches):
                guard let match = matches.first else {
                    completion(.failure(.custom("No matches found for tournament ID \(tournamentId).")))
                    return
                }
                
                if match.referee_password == refereePassword {
                    completion(.success(match))
                } else {
                    completion(.failure(.custom("Wrong password")))
                }

            case .failure(let error):
                completion(.failure(.custom("Network Error: \(error.localizedDescription)")))
            }
        }
    }

    func updateMatchResult(tournamentId: String, matchId: String, results: [Int], refereePassword: String, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        guard !tournamentId.isEmpty else {
            completion(.failure(.custom("Tournament ID cannot be empty.")))
            return
        }

        guard !matchId.isEmpty else {
            completion(.failure(.custom("Match ID cannot be empty.")))
            return
        }

        guard !results.isEmpty else {
            completion(.failure(.custom("Results cannot be empty.")))
            return
        }

        guard !refereePassword.isEmpty else {
            completion(.failure(.custom("Referee Password cannot be empty.")))
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

        networkService.update(url: url, parameters: parameters, headers: headers) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(.custom("Network Error: \(error.localizedDescription)")))
            }
        }
    }
}
