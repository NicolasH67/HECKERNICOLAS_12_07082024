//
//  NetworkHome.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 17/10/2024.
//

import SwiftUI

struct NetworkHomeView: View {
    var tournamentId: String
    var matchId: String
    
    var body: some View {
        ZStack {
            Color.red.opacity(0.3)
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 15) {
                Group {
                    Text("Player One")
                        .font(.headline)
                        .padding(.leading)
                    
                    Text(tournamentId)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                        .disabled(true)
                }

                Group {
                    Text("Player Two")
                        .font(.headline)
                        .padding(.leading)

                    Text(matchId)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                        .disabled(true)
                }
                
                Divider()

                Button(action: {
                    print("\(tournamentId) vs \(matchId)")
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
            }
        }
    }
}
