//
//  NetworkHome.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 17/10/2024.
//

import SwiftUI

struct NetworkHomeView: View {
    //Faire un modal avec un premier ecran que avec tournament id et match id et un bouton find et un mot de passe et un second avec les parametre du match
    @State var tournamentId: String = ""
    @State var matchId: String = ""
    var body: some View {
        
        ZStack {
            Color.red.opacity(0.3)
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 15) {
                // Player One
                Group {
                    Text("Player One")
                        .font(.headline)
                        .padding(.leading)
                    
                    TextField("Player one", text: $tournamentId)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                }

                // Player Two
                Group {
                    Text("Player Two")
                        .font(.headline)
                        .padding(.leading)

                    TextField("Player two", text: $matchId)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                }

                //BestOf()
                
                Divider()

                //FirstServe()

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
    NetworkHomeView()
}
