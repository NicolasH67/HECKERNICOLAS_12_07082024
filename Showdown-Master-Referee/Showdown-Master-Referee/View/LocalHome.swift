//
//  Home.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 11/10/2024.
//

import SwiftUI

struct LocalHome: View {
    @State var playerOneName: String = ""
    @State var playerTwoName: String = ""
    
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

                BestOf()

                Divider()

                CounterView()

                FirstServe()

                // Start Game Button
                Button(action: {
                    print("\(playerOneName) vs \(playerTwoName)")
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
    LocalHome()
}
