//
//  Match.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 21/10/2024.
//

import SwiftUI

struct Match: View {
    var playerOne: String = "Player One"
    var playerTwo: String = "Player Two"
    var bestOf: String = "Best of 3"
    var numberOfServicePlayerOne: Int = 2
    var numberOfServicePlayerTwo: Int = 0
    var pointsPlayerOne: Int = 11
    var pointsPlayerTwo: Int = 9
    var setWinPlayerOne: Int = 2
    var setWinPlayerTwo: Int = 1
    
    var body: some View {
        ZStack {
            Color.red.opacity(0.3)
                .ignoresSafeArea()
            
            HStack {
                VStack {
                    Text(playerOne)
                    HStack(spacing: 0) {
                        Button(action: {}) {
                            Text("P/W")
                        }
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(Color.white)
                        Button(action: {}) {
                            Text("TO")
                        }
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(Color.white)
                    }
                    Text("\(numberOfServicePlayerOne)")
                        .padding()
                    Button(action: {}) {
                        Text("Goal player 1")
                    }
                    .padding()
                    .background(Color.indigo)
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity)
                    
                    Button(action: {}) {
                        Text("Fault player 1")
                    }
                    .padding()
                    .background(Color.indigo)
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity) // Étend la première colonne
                
                VStack {
                    Text(bestOf)
                    HStack(spacing: 0) {
                        Text("\(pointsPlayerOne)")
                        Text("\(setWinPlayerOne)")
                        Text("\(setWinPlayerTwo)")
                        Text("\(pointsPlayerTwo)")
                    }
                    Button(action: {}) {
                        Text("Back")
                    }
                    .padding()
                    .background(Color.red)
                    .foregroundColor(Color.white)
                    
                    Button(action: {}) {
                        Text("Start Chrono")
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(Color.white)
                    
                    Button(action: {}) {
                        Text("End of Set")
                    }
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(Color.black)
                }
                .frame(maxWidth: .infinity) // Étend la colonne centrale
                
                VStack {
                    Text(playerOne)
                    HStack(spacing: 0) {
                        Button(action: {}) {
                            Text("P/W")
                        }
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(Color.white)
                        Button(action: {}) {
                            Text("TO")
                        }
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(Color.white)
                    }
                    Text("\(numberOfServicePlayerTwo)")
                        .padding()
                    Button(action: {}) {
                        Text("Goal player 1")
                    }
                    .padding()
                    .background(Color.indigo)
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity)
                    
                    Button(action: {}) {
                        Text("Fault player 1")
                    }
                    .padding()
                    .background(Color.indigo)
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity) // Étend la première colonne
            }
        }
    }
}

#Preview {
    Match()
}
