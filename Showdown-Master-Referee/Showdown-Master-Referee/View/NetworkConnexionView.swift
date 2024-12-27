//
//  NetworkConnexion.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 22/10/2024.
//

import SwiftUI

struct NetworkConnexionView: View {
    @StateObject private var viewModel: NetworkConnexionViewModel

    init() {
        _viewModel = StateObject(wrappedValue: NetworkConnexionViewModel())
    }

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

                        TextField("Tournament ID", text: $viewModel.tournamentId)
                            .textFieldStyle(.roundedBorder)
                            .padding(.horizontal)
                            .keyboardType(.numberPad)
                    }

                    Group {
                        Text("Match ID")
                            .font(.headline)
                            .padding(.leading)

                        TextField("Match ID", text: $viewModel.matchId)
                            .textFieldStyle(.roundedBorder)
                            .padding(.horizontal)
                            .keyboardType(.numberPad)
                    }

                    Group {
                        Text("Password")
                            .font(.headline)
                            .padding(.leading)

                        HStack {
                            if viewModel.showPassword {
                                TextField("Password", text: $viewModel.password)
                                    .textFieldStyle(.roundedBorder)
                            } else {
                                SecureField("Password", text: $viewModel.password)
                                    .textFieldStyle(.roundedBorder)
                            }

                            Button(action: viewModel.togglePasswordVisibility) {
                                Image(systemName: viewModel.showPassword ? "eye.slash" : "eye")
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

                    Button(action: viewModel.fetchMatch) {
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
                .alert(isPresented: $viewModel.showAlert) {
                    Alert(title: Text("Message"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
                }
            }
            .sheet(isPresented: $viewModel.showMatchResultPopup, onDismiss: viewModel.dismissMatchResult) {
                MatchResultPopup(
                    playerOneName: viewModel.playerOne,
                    playerTwoName: viewModel.playerTwo,
                    matchResults: viewModel.matchResult,
                    onDismiss: viewModel.dismissMatchResult
                )
            }
            .navigationDestination(isPresented: $viewModel.navigateToGame) {
                NetworkHomeView(
                    playerOneName: viewModel.playerOne,
                    playerTwoName: viewModel.playerTwo,
                    matchId: viewModel.matchId,
                    tournamentId: viewModel.tournamentId,
                    refereePassword: viewModel.password
                )
            }
        }
    }
}

#Preview {
    NetworkConnexionView()
}
