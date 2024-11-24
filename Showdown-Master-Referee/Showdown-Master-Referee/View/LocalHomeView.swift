//
//  LocalHome.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 11/10/2024.
//

import SwiftUI

struct LocalHomeView: View {
    @EnvironmentObject var matchGestion: MatchGestion
    @State var playerOneName: String = ""
    @State var playerTwoName: String = ""
    @State var coachPlayerOneName: String = ""
    @State var coachPlayerTwoName: String = ""
    @State var bestOfSelectedPicker: Int = 0
    @State var numberOfSet: Int = 1
    @State var pointsPerSet: Int = 11
    @State var numberOfService: Int = 2
    @State var changeSide: Bool = true
    @State private var matchModel: MatchModel?
    @State private var isMatchModelReady = false
    @State var firstServeSelectedPicker: Int = 0
    let bestOfOptions = ["Best of 1", "Best of 3", "Best of 5", "Team", "Custom"]

    var body: some View {
        NavigationStack {
            ZStack {
                Color.red.opacity(0.3)
                    .ignoresSafeArea()

                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Group {
                            Text("Player One :")
                                .font(.headline)
                                .padding(.leading)

                            TextField("Player one name", text: $playerOneName)
                                .textFieldStyle(.roundedBorder)
                                .padding(.horizontal)
                        }
                    }

                    HStack {
                        Group {
                            Text("Player Two :")
                                .font(.headline)
                                .padding(.leading)

                            TextField("Player two name", text: $playerTwoName)
                                .textFieldStyle(.roundedBorder)
                                .padding(.horizontal)
                        }
                    }

                    BestOfView(
                        bestOfSelectedPicker: $bestOfSelectedPicker,
                        numberOfSetInt: $numberOfSet,
                        pointsPerSetInt: $pointsPerSet,
                        numberOfServiceInt: $numberOfService,
                        changeSide: $changeSide
                    )
                    
                    Divider()
                    
                    FirstServeView(firstServeSelectedPicker: $firstServeSelectedPicker)

                    Button(action: {
                        var playerOneServeChoice: Bool = false
                        if firstServeSelectedPicker == 0 {
                            playerOneServeChoice = true
                        } else {
                            playerOneServeChoice = false
                        }
                        
                        matchGestion.matchModel = MatchModel(
                            playerOne: playerOneName,
                            playerTwo: playerTwoName,
                            numberOfService: numberOfService,
                            numberOfPoints: pointsPerSet,
                            numberOfSet: numberOfSet,
                            bestOf: bestOfOptions[bestOfSelectedPicker],
                            playerOneFirstServe: playerOneServeChoice,
                            changeSide: changeSide
                        )
                        isMatchModelReady = true
                    }) {
                        ZStack {
                            Color.blue.opacity(0.8)
                            Label("Start Game", systemImage: "play.circle")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding()
                        }
                        .cornerRadius(10)
                        .padding(.horizontal)
                    }
                    .padding(.top)
                    .navigationDestination(isPresented: $isMatchModelReady) {
                        MatchView()
                    }
                }
            }
        }
    }
}

#Preview {
    LocalHomeView(playerOneName: "Nicolas", playerTwoName: "Fidan", bestOfSelectedPicker: 2, numberOfSet: 3, pointsPerSet: 11, numberOfService: 2, changeSide: true)
}
