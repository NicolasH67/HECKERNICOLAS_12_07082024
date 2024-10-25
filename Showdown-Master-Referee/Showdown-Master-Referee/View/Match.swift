//  Match.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 21/10/2024.
//

import SwiftUI

struct Match: View {
    var playerOne: String = "Hecker Nicolas"
    var playerTwo: String = "FAURE-MAYOL Fidan"
    var bestOf: String = "Best of 5"
    @State var numberOfServicePlayerOne: Int = 1
    @State var numberOfServicePlayerTwo: Int = 0
    var totalService: Int = 2
    @State var pointsPlayerOne: Int = 0
    @State var pointsPlayerTwo: Int = 0
    @State var setWinPlayerOne: Int = 0
    @State var setWinPlayerTwo: Int = 0
    @State var isPlayerOneServe: Bool = true
    var numberOfService: Int = 2
    
    
    var body: some View {
        ZStack {
            Color(.red)
                .opacity(0.3)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                // Header with Player Names and Best Of
                HStack {
                    Text(playerOne)
                        .font(.headline)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Text(bestOf)
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    Text(playerTwo)
                        .font(.headline)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(.horizontal)
                
                // Score display
                HStack(spacing: 40) {
                    ScoreBox(title: "Points", value: pointsPlayerOne)
                    ScoreBox(title: "Sets", value: setWinPlayerOne)
                    Spacer()
                    ScoreBox(title: "Sets", value: setWinPlayerTwo)
                    ScoreBox(title: "Points", value: pointsPlayerTwo)
                }
                
                // Action Buttons and Services
                HStack(spacing: 40) {
                    PlayerActionView(
                        totalService: totalService,
                        currentService: numberOfServicePlayerOne,
                        onGoal: {
                            pointsPlayerOne += 2
                        },
                        onFault: {
                            pointsPlayerTwo += 1
                        },
                        onServe: {
                            self.onServe(isPlayerOne: true)
                        }
                    )
                    PlayerActionView(
                        totalService: totalService,
                        currentService: numberOfServicePlayerTwo,
                        onGoal: {
                            pointsPlayerTwo += 2
                        },
                        onFault: {
                            pointsPlayerOne += 1
                        },
                        onServe: {
                            self.onServe(isPlayerOne: false)
                        }
                    )
                }
                
                // Chrono and Set Management
                VStack(spacing: 10) {
                    Button(action: {}) {
                        Text("Start Chrono")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    Button(action: {}) {
                        Text("End of Set")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    Button(action: {}) {
                        Text("Back")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal, 30)
            } // VStack main content
            .padding()
        }
    }

    func onServe(isPlayerOne: Bool) {
        if isPlayerOneServe {
            if numberOfServicePlayerOne < numberOfService {
                numberOfServicePlayerOne += 1
            } else {
                numberOfServicePlayerOne = 0
                numberOfServicePlayerTwo = 1
                isPlayerOneServe = false
            }
        } else {
            if numberOfServicePlayerTwo < numberOfService {
                numberOfServicePlayerTwo += 1
            } else {
                numberOfServicePlayerTwo = 0
                numberOfServicePlayerOne = 1
                isPlayerOneServe = true
            }
        }
    }
}

struct ScoreBox: View {
    var title: String
    var value: Int
    
    var body: some View {
        VStack {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            
            Text("\(value)")
                .font(.system(size: 20))
                .fontWeight(.bold)
                .frame(width: 60, height: 60)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
    }
}

struct PlayerActionView: View {
    var totalService: Int
    var currentService: Int
    var onGoal: () -> Void
    var onFault: () -> Void
    var onServe: () -> Void
    @State var timeOutButtonIsDisabled: Bool = false
    
    var body: some View {
        VStack(spacing: 10) {
            // Boutons P/W et TO
            HStack(spacing: 2) {
                Button(action: {}) {
                    Text("P/W")
                        .frame(minWidth: 40, minHeight: 40)
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    timeOutButtonIsDisabled = true
                }) {
                    Text("TO")
                        .frame(minWidth: 40, minHeight: 40)
                        .padding()
                        .background(timeOutButtonIsDisabled ? Color.red : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            
            Text("Service")
                .font(.caption)
                .foregroundColor(.gray)
            
            HStack(spacing: 10) {
                ForEach(0..<totalService, id: \.self) { index in
                    Circle()
                        .strokeBorder(Color.gray, lineWidth: 2)
                        .background(Circle().fill(index < currentService ? Color.blue : Color.clear))
                        .frame(width: 30, height: 30)
                }
            }
            
            // Boutons Goal et Fault
            Button(action: {
                onGoal()
                onServe()
            }) {
                Text("Goal")
                    .frame(minWidth: 100, minHeight: 50)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity)
            }
            
            Button(action: {
                onFault()
                onServe()
            }) {
                Text("Fault")
                    .frame(minWidth: 100, minHeight: 50)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    Match()
}
