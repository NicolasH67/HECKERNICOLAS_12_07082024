//
//  MockNetworkService.swift
//  Showdown-Master-RefereeTest
//
//  Created by Nicolas Hecker on 15/01/2025.
//

import Foundation
import Alamofire
@testable import Showdown_Master_Referee

class MockNetworkService: NetworkService {
    var fetchResult: Result<[Match], Error>?
    var updateError: Error?

    func fetch<T: Decodable>(from url: String, headers: HTTPHeaders, completion: @escaping (Result<T, Error>) -> Void) {
        if let fetchResult = fetchResult as? Result<T, Error> {
            completion(fetchResult)
        } else {
            completion(.failure(NetworkError.custom("Mock fetch result not set")))
        }
    }

    func update(url: String, parameters: [String: Any], headers: HTTPHeaders, completion: @escaping (Result<Void, Error>) -> Void) {
        if let updateError = updateError {
            completion(.failure(updateError))
        } else {
            completion(.failure(NetworkError.custom("Mock update not implemented")))
        }
    }
}

class MockNetworkManager: NetworkManager {
    var fetchMatchResult: Result<Match, NetworkError>?
    var updateMatchResultError: NetworkError?

    override func fetchMatch(tournamentId: String, matchId: String, refereePassword: String, completion: @escaping (Result<Match, NetworkError>) -> Void) {
        if let fetchMatchResult = self.fetchMatchResult {
            completion(fetchMatchResult)
        } else {
            completion(.failure(.custom("Mock fetchMatchResult not set")))
        }
    }

    func updateMatch(tournamentId: String, matchId: String, results: [Int], completion: @escaping (Result<Void, NetworkError>) -> Void) {
        if let error = updateMatchResultError {
            completion(.failure(error))
        } else {
            completion(.success(()))
        }
    }
}


