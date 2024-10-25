//
//  LocalHome.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 11/10/2024.
//

import SwiftUI

struct LocalHome: View {
    
    @State var playerOneName: String = ""
    @State var playerTwoName: String = ""
    @State var bestOfSelectedPicker: Int = 0
    @State var numberOfSet: Int = 1
    @State var pointsPerSet: Int = 11
    @State var numberOfService: Int = 2
    @State var changeSide: Bool = true
    let bestOfOptions = ["Best of 1", "Best of 3", "Best of 5", "Team", "Custom"]

    var body: some View {
        NavigationStack {
            ZStack {
                Color.red.opacity(0.3)
                    .ignoresSafeArea()

                VStack(alignment: .leading, spacing: 15) {
                    // Player One
                    Group {
                        Text("Player One")
                            .font(.headline)
                            .padding(.leading)

                        TextField("Player one name", text: $playerOneName)
                            .textFieldStyle(.roundedBorder)
                            .padding(.horizontal)
                    }

                    // Player Two
                    Group {
                        Text("Player Two")
                            .font(.headline)
                            .padding(.leading)

                        TextField("Player two name", text: $playerTwoName)
                            .textFieldStyle(.roundedBorder)
                            .padding(.horizontal)
                    }

                    // Sélecteur "Best Of"
                    BestOf(
                        bestOfSelectedPicker: bestOfSelectedPicker,
                        numberOfSetInt: numberOfSet,
                        pointsPerSetInt: pointsPerSet,
                        numberOfServiceInt: numberOfService,
                        changeSide: changeSide
                    )
                    
                    Divider()

                    FirstServe()

                    // Start Game Button
                    NavigationLink(destination: Match()) {
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
                }
            }
        }
    }
}

#Preview {
    LocalHome(playerOneName: "Nicolas", playerTwoName: "Fidan", bestOfSelectedPicker: 2, numberOfSet: 3, pointsPerSet: 11, numberOfService: 2, changeSide: true)
}
