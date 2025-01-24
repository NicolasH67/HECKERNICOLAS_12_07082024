//
//  NetworkManager.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 22/11/2024.
//

import Foundation
import Alamofire

/// Protocol defining the network service operations.
/// These operations provide methods to fetch and update data from the network.
protocol NetworkService {
    /// Fetches data from a URL and decodes it into a specified type.
    /// - Parameters:
    ///   - url: The URL to fetch the data from.
    ///   - headers: The HTTP headers to include in the request.
    ///   - completion: A closure that will be called when the request completes, with the result being either success with the decoded data, or failure with an error.
    func fetch<T: Decodable>(from url: String, headers: HTTPHeaders, completion: @escaping (Result<T, Error>) -> Void)

    /// Updates data at the specified URL with the given parameters.
    /// - Parameters:
    ///   - url: The URL to send the update request to.
    ///   - parameters: The parameters to send with the request.
    ///   - headers: The HTTP headers to include in the request.
    ///   - completion: A closure that will be called when the request completes, indicating success or failure.
    func update(url: String, parameters: [String: Any], headers: HTTPHeaders, completion: @escaping (Result<Void, Error>) -> Void)
}

/// A network service implementation using Alamofire for performing HTTP requests.
class AlamofireNetworkService: NetworkService {
    /// Fetches data from a URL and decodes it into a specified type.
    ///
    /// - Parameters:
    ///   - url: The URL to fetch the data from.
    ///   - headers: The HTTP headers to include in the request.
    ///   - completion: A closure that will be called when the request completes, with the result being either success with the decoded data, or failure with an error.
    func fetch<T: Decodable>(from url: String, headers: HTTPHeaders, completion: @escaping (Result<T, Error>) -> Void) {
        print(url)
        AF.request(url, headers: headers).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    /// Updates data at the specified URL with the given parameters.
    ///
    /// - Parameters:
    ///   - url: The URL to send the update request to.
    ///   - parameters: The parameters to send with the request.
    ///   - headers: The HTTP headers to include in the request.
    ///   - completion: A closure that will be called when the request completes, indicating success or failure.
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

/// Enum representing custom network errors for the `NetworkManager`.
enum NetworkError: Error {
    case custom(String)
}

/// Manager responsible for handling network requests related to matches, using a `NetworkService` for network operations.
/// - Provides functionality to fetch match details and update match results.
class NetworkManager {
    private let networkService: NetworkService
    private let config = Config()

    /// Initializes the `NetworkManager` with a custom `NetworkService` (default is `AlamofireNetworkService`).
    /// - Parameter networkService: The network service used for network operations.
    init(networkService: NetworkService = AlamofireNetworkService()) {
        self.networkService = networkService
    }

    /// Fetches match details based on the provided tournament and match IDs, and referee password.
    /// - Parameters:
    ///   - tournamentId: The ID of the tournament.
    ///   - matchId: The ID of the match.
    ///   - refereePassword: The referee's password to validate access.
    ///   - completion: A closure that returns either the fetched match or an error.
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

        let url = "\(config.baseUrl)/matchs?tournament_id=eq.\(tournamentId)&match_id=eq.\(matchId)&apikey=\(config.apiKey)"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(config.apiKey)",
            "apikey": config.apiKey,
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

    /// Updates the result of a match based on the provided tournament and match IDs, results, and referee password.
    /// - Parameters:
    ///   - tournamentId: The ID of the tournament.
    ///   - matchId: The ID of the match.
    ///   - results: The results of the match.
    ///   - refereePassword: The referee's password to validate the request.
    ///   - completion: A closure that returns either success or an error.
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

        let url = "\(config.baseUrl)/matchs?match_id=eq.\(matchId)&tournament_id=eq.\(tournamentId)"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(config.apiKey)",
            "apikey": config.apiKey,
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
