//
//  NetworkConnexion.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 22/10/2024.
//

import SwiftUI

struct NetworkConnexion: View {
    @State var tournamentId: String = ""
    @State var matchId: String = ""
    @State var password: String = ""
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
                
                Group {
                    Text("Password")
                        .font(.headline)
                        .padding(.leading)
                    
                    TextField("Password", text: $password)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                }
                
                Divider()
                
//                Button(action: {
//                    print("")
//                }) {
//                    ZStack {
//                        Color.blue.opacity(0.8)
//                        Label("Start Game", systemImage: "play.circle")
//                            .font(.title)
//                            .foregroundColor(.white)
//                            .padding()
//                    }
//                    .cornerRadius(10)
//                    .padding(.horizontal)
//                }
//                .padding(.top)
                
                Button(action: {
                    
                }) {
                    ZStack {
                        Color.blue.opacity(0.8)
                        Label("Connect", systemImage: "play.circle")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                    }
                    .cornerRadius(10)
                    .padding(.top)
                }
                .frame(maxHeight: 100)
                .padding(.leading)
                .padding(.trailing)
            }
        }
    }
}

#Preview {
    NetworkConnexion()
}
