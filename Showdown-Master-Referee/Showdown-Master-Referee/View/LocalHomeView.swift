//
//  LocalHome.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 11/10/2024.
//

import SwiftUI

struct LocalHomeView: View {
    @StateObject private var viewModel = LocalHomeViewModel()
    
    var body: some View {
        NavigationStack {
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
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Setup Match")
            .navigationBarTitleDisplayMode(.inline)
            .fullScreenCover(isPresented: $viewModel.isMatchModelReady) {
                if let matchModel = viewModel.matchModel {
                    MatchView(matchModel: matchModel)
                } else {
                    Text("Match model is not readu.")
                }
            }
        }
    }
}

#Preview {
    LocalHomeView()
}
