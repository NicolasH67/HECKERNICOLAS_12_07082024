//
//  NetworkConnexionViewModel.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 15/12/2024.
//

import SwiftUI

class NetworkConnexionViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var tournamentId: String = ""
    @Published var matchId: String = ""
    @Published var password: String = ""
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var navigateToGame: Bool = false
    @Published var playerOne: String = ""
    @Published var playerTwo: String = ""
    @Published var showPassword: Bool = false
    @Published var matchResult: [Int] = []
    @Published var showMatchResultPopup: Bool = false
    
    // MARK: - Properties
    
    var networkManager: NetworkManager
    
    // MARK: - Initializer
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    // MARK: - Methods

    /// Toggles the visibility of the password by changing the `showPassword` state.
    func togglePasswordVisibility() {
        showPassword.toggle()
    }

    /// Fetches match details from the network and handles success or failure response.
    func fetchMatch() {
        networkManager.fetchMatch(
            tournamentId: tournamentId,
            matchId: matchId,
            refereePassword: password
        ) { result in
            switch result {
            case .success(let match):
                if let result = match.result, !result.isEmpty {
                    self.playerOne = match.player_one
                    self.playerTwo = match.player_two
                    self.matchResult = result
                    self.showMatchResultPopup = true
                } else {
                    self.playerOne = match.player_one
                    self.playerTwo = match.player_two
                    self.navigateToGame = true
                }
            case .failure(let error):
                if case let NetworkError.custom(errorMessage) = error {
                    self.alertMessage = errorMessage
                }
                self.showAlert = true
            }
        }
    }
    
    /// Dismisses the match result popup by setting `showMatchResultPopup` to false.
    func dismissMatchResult() {
        showMatchResultPopup = false
    }
}
