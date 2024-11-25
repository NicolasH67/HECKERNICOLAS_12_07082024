//
//  NetworkConnexion.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 22/10/2024.
//

import SwiftUI

struct NetworkConnexionView: View {
    @State private var tournamentId: String = ""
    @State private var matchId: String = ""
    @State private var password: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var navigateToGame: Bool = false
    @State private var playerOne: String = ""
    @State private var playerTwo: String = ""
    @State private var showPassword: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.red.opacity(0.3)
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 15) {
                    Group {
                        Text("Tournament ID")
                            .font(.headline)
                            .padding(.leading)
                        
                        TextField("Tournament ID", text: $tournamentId)
                            .textFieldStyle(.roundedBorder)
                            .padding(.horizontal)
                    }
                    
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
                        
                        HStack {
                            if showPassword {
                                TextField("Password", text: $password)
                                    .textFieldStyle(.roundedBorder)
                            } else {
                                SecureField("Password", text: $password)
                                    .textFieldStyle(.roundedBorder)
                            }
                            
                            Button(action: {
                                showPassword.toggle()
                            }) {
                                Image(systemName: showPassword ? "eye.slash" : "eye")
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    Divider()
                    
                    Button(action: fetchMatch) {
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
                    .padding(.horizontal)
                    .navigationDestination(isPresented: $navigateToGame) {
                        NetworkHomeView(tournamentId: tournamentId, matchId: matchId)
                    }
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Message"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }
        }
    }
    
    private func fetchMatch() {
        NetworkManager.shared.fetchMatch(
            tournamentId: tournamentId,
            matchId: matchId,
            refereePassword: password
        ) { match, error in
            if let error = error {
                alertMessage = error
                showAlert = true
            } else if let match = match {
                if let result = match.result, !result.isEmpty {
                    // Si un résultat existe, afficher une alerte avec le résultat
                    alertMessage = "Ce match a déjà un résultat : \(result)"
                    showAlert = true
                } else {
                    // Si le résultat est vide, préparer les données des joueurs pour la navigation
                    playerOne = match.player_one
                    playerTwo = match.player_two
                    navigateToGame = true
                }
            }
        }
    }
}
