//
//  NetworkConnexionViewModel.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 15/12/2024.
//

import SwiftUI

class NetworkConnexionViewModel: ObservableObject {
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
    var networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }

    func togglePasswordVisibility() {
        showPassword.toggle()
    }

    func fetchMatch() {
        networkManager.fetchMatch(
            tournamentId: tournamentId,
            matchId: matchId,
            refereePassword: password
        ) { result in
            DispatchQueue.main.async {
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
                    self.alertMessage = error.localizedDescription
                    self.showAlert = true
                }
            }
        }
    }
    
    func dismissMatchResult() {
        showMatchResultPopup = false
    }
}
