//
//  NetworkHome.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 17/10/2024.
//

import SwiftUI

struct NetworkHome: View {
    @State var tournamentId: String = ""
    @State var matchId: String = ""
    var body: some View {
        
        ZStack {
            Color.red.opacity(0.3)
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 15) {
                // Player One
                Group {
                    Text("Tournament ID")
                        .font(.headline)
                        .padding(.leading)
                    
                    TextField("Tournament ID", text: $tournamentId)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                }

                // Player Two
                Group {
                    Text("Match ID")
                        .font(.headline)
                        .padding(.leading)

                    TextField("Match ID", text: $matchId)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                }

                BestOf()
                
                Divider()

                FirstServe()

                // Start Game Button
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

#Preview {
    NetworkHome()
}
