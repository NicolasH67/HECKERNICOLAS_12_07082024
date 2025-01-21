//
//  NetworkConnexionViewModelTest.swift
//  Showdown-Master-RefereeTest
//
//  Created by Nicolas Hecker on 15/01/2025.
//

import Testing
import XCTest
@testable import Showdown_Master_Referee

struct NetworkConnexionViewModelTest {

    @Test("When dismiss match result is called, showMatchResultPopup is set to false")
    func whenDismissMatchResultIsCalled_thenShowMatchResultPopupIsFalse() {
        let viewModel = NetworkConnexionViewModel(networkManager: NetworkManager())
        viewModel.showMatchResultPopup = true
        viewModel.dismissMatchResult()
        
        #expect(viewModel.showMatchResultPopup == false)
    }
    
    @Test("When toggle password visibility is called, showPassword toggles correctly")
    func whenTogglePasswordVisibilityIsCalled_thenShowPasswordToggles() {
        let viewModel = NetworkConnexionViewModel(networkManager: NetworkManager())
        
        viewModel.togglePasswordVisibility()
        #expect(viewModel.showPassword == true)
        
        viewModel.togglePasswordVisibility()
        #expect(viewModel.showPassword == false)
    }
    
    @Test("When fetch match is called with a result, match details are updated correctly")
    func whenFetchMatchIsCalledWithResult_thenMatchDetailsAreUpdated() async throws {
        let mockNetworkManager = MockNetworkManager(networkService: MockNetworkService())
        let viewModel = NetworkConnexionViewModel(networkManager: mockNetworkManager)
        
        let match = Match(
            id: 1,
            player_one: "Player One",
            player_two: "Player Two",
            referee_password: "referee",
            match_id: 1,
            tournament_id: 1,
            result: [11, 9]
        )
        
        viewModel.tournamentId = "1"
        viewModel.matchId = "1"
        viewModel.password = "referee"
        
        mockNetworkManager.fetchMatchResult = .success(match)
        
        viewModel.fetchMatch()
        
        try await Task.sleep(for: .milliseconds(100))
        
        #expect(viewModel.playerOne == "Player One")
        #expect(viewModel.playerTwo == "Player Two")
        #expect(viewModel.matchResult == [11, 9])
        #expect(viewModel.showMatchResultPopup == true)
        #expect(viewModel.navigateToGame == false)
    }
    
    @Test("When fetch match is called without a result, match details are updated and navigateToGame is true")
    func whenFetchMatchIsCalledWithoutResult_thenMatchDetailsAreUpdatedAndNavigateToGameIsTrue() async throws {
        let mockNetworkManager = MockNetworkManager(networkService: MockNetworkService())
        let viewModel = NetworkConnexionViewModel(networkManager: mockNetworkManager)

        let match = Match(
            id: 1,
            player_one: "Player One",
            player_two: "Player Two",
            referee_password: "referee",
            match_id: 1,
            tournament_id: 1,
            result: []
        )

        viewModel.tournamentId = "1"
        viewModel.matchId = "1"
        viewModel.password = "referee"
        
        mockNetworkManager.fetchMatchResult = .success(match)

        viewModel.fetchMatch()
        
        //try await Task.sleep(for: .seconds(0.1))

        #expect(viewModel.playerOne == "Player One")
        #expect(viewModel.playerTwo == "Player Two")
        #expect(viewModel.matchResult == [])
        #expect(viewModel.showMatchResultPopup == false)
        #expect(viewModel.navigateToGame == true)
    }
    
    @Test("When fetch match fails, an alert message is displayed")
    func whenFetchMatchFails_thenAlertMessageIsDisplayed() async throws {
        let mockNetworkManager = MockNetworkManager(networkService: MockNetworkService())
        let viewModel = NetworkConnexionViewModel(networkManager: mockNetworkManager)
        
        viewModel.tournamentId = "1"
        viewModel.matchId = "1"
        viewModel.password = "referee"
        
        mockNetworkManager.fetchMatchResult = .failure(NetworkError.custom("Error"))
        
        viewModel.fetchMatch()
        
//        try await Task.sleep(for: .seconds(1))
        
        #expect(viewModel.alertMessage == "Error")
    }
}
