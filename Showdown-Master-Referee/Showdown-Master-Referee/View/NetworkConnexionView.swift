//
//  NetworkConnexion.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 22/10/2024.
//

import SwiftUI

struct NetworkConnexionView: View {
    @EnvironmentObject var matchGestion: MatchGestion
    @State private var tournamentId: String = ""
    @State private var matchId: String = ""
    @State private var password: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var navigateToGame: Bool = false
    @State private var playerOne: String = ""
    @State private var playerTwo: String = ""
    @State private var showPassword: Bool = false
    @State private var matchResult: [Int] = []
    
    var body: some View {
        NavigationStack {
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
                                    .foregroundColor(Color("Deep Purple"))
                                    .padding(8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color("Deep Purple"), lineWidth: 1)
                                            .background(Color.white.cornerRadius(8))
                                    )
                            }
                        }
                        .padding(.horizontal)
                    }

                    Divider()
                    
                    Button(action: fetchMatch) {
                        ZStack {
                            LinearGradient(
                                colors: [Color("Deep Purple"), Color("Raspberry Pink")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                            .opacity(0.9)
                            .cornerRadius(10)
                            .shadow(color: Color.blue.opacity(0.5), radius: 10, x: 0, y: 5)
                            
                            HStack(spacing: 10) {
                                Image(systemName: "play.circle.fill")
                                    .font(.title)
                                    .foregroundColor(.white)
                                Text("Connect")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                            .padding()
                        }
                    }
                    .frame(maxHeight: 100)
                    .padding(.horizontal)

                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Message"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }
            .sheet(isPresented: $matchGestion.showMatchResultPopup, onDismiss: matchGestion.dismissMatchResult) {
                MatchResultPopup(
                    playerOneName: playerOne,
                    playerTwoName: playerTwo,
                    matchResults: matchResult,
                    onDismiss: matchGestion.dismissMatchResult
                )
            }
            .navigationDestination(isPresented: $navigateToGame) {
                NetworkHomeView(
                    tournamentId: tournamentId,
                    matchId: matchId,
                    playerOneName: playerOne,
                    playerTwoName: playerTwo
                )
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
                    playerOne = match.player_one
                    playerTwo = match.player_two
                    matchResult = match.result ?? []
                    print(playerOne)
                    print(playerTwo)
                    print(matchResult)
                    matchGestion.showMatchResultPopup = true
                } else {
                    playerOne = match.player_one
                    playerTwo = match.player_two
                    print("Player One is : \(playerOne), Player Two is : \(playerTwo)")
                    navigateToGame = true
                }
            } else {
                
            }
        }
    }
}
