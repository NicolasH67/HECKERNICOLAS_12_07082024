//
//  LocalHome.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 11/10/2024.
//

import SwiftUI

struct LocalHomeView: View {
    @StateObject private var viewModel = LocalHomeViewModel()
    @Binding var path: NavigationPath
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Color(.red)
                    .opacity(0.3)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        SectionHeader(title: "Players and Coaches")
                        
                        PlayerEntryView(
                            playerTitle: "Player One",
                            name: $viewModel.playerOneName,
                            coachName: $viewModel.coachPlayerOneName,
                            isEditable: true
                        )
                        
                        PlayerEntryView(
                            playerTitle: "Player Two",
                            name: $viewModel.playerTwoName,
                            coachName: $viewModel.coachPlayerTwoName,
                            isEditable: true
                        )
                        
                        SectionHeader(title: "Match Settings")
                        
                        BestOfView(
                            bestOfSelectedPicker: $viewModel.bestOfSelectedPicker,
                            numberOfSetInt: $viewModel.numberOfSet,
                            pointsPerSetInt: $viewModel.pointsPerSet,
                            numberOfServiceInt: $viewModel.numberOfService,
                            changeSide: $viewModel.changeSide
                        )
                        
                        FirstServeView(firstServeSelectedPicker: $viewModel.firstServeSelectedPicker)
                        
                        StartGameButton {
                            viewModel.startMatch()
                            if let matchModel = viewModel.matchModel {
                                path.append(matchModel)
                            } else {
                                print("Match model is not ready.")
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Setup Match")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: MatchModel.self) { matchModel in
                MatchView(
                    matchModel: matchModel,
                    networkManager: NetworkManager(),
                    path: $path
                )
            }
        }
    }
}
