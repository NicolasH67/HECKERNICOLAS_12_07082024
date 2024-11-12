//  Match.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 21/10/2024.
//

import SwiftUI

struct MatchView: View {
    var matchModel: MatchModel?
    @State var numberOfServicePlayerOne: Int = 0
    @State var numberOfServicePlayerTwo: Int = 0
    @State var pointsPlayerOne: Int = 0
    @State var pointsPlayerTwo: Int = 0
    @State var setWinPlayerOne: Int = 0
    @State var setWinPlayerTwo: Int = 0
    @State var isPlayerOneServe: Bool = true
    @State private var showCountdownPopup = false
    @State private var countdownTime = 60
    @State private var countdownTimer: Timer?
    @State private var matchIsOver: Bool = false
    @State private var changeSide: Bool = false
    
    var body: some View {
        ZStack {
            Color(.red)
                .opacity(0.3)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                // Header with Player Names and Best Of
                HStack {
                    Text(matchModel?.playerOne ?? "Player One")
                        .font(.headline)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Text(matchModel?.bestOf ?? "Best Of")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    Text(matchModel?.playerTwo ?? "Player Two")
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
                        totalService: matchModel?.numberOfService ?? 0,
                        currentService: numberOfServicePlayerOne,
                        onGoal: {
                            self.onGoal(isPlayerOneScored: true)
                        },
                        onFault: {
                            pointsPlayerTwo += 1
                        },
                        onServe: {
                            self.onServe(isPlayerOne: true)
                        },
                        startCountdown: {
                            self.stopCountdown()
                        },
                        initializeFirstServe: {
                            self.initializeServiceCounts()
                        },
                        matchIsOver: matchIsOver
                    )
                    PlayerActionView(
                        totalService: matchModel?.numberOfService ?? 0,
                        currentService: numberOfServicePlayerTwo,
                        onGoal: {
                            self.onGoal(isPlayerOneScored: false)
                        },
                        onFault: {
                            pointsPlayerOne += 1
                        },
                        onServe: {
                            self.onServe(isPlayerOne: false)
                        },
                        startCountdown: {
                            self.stopCountdown()
                        },
                        initializeFirstServe: {
                            self.initializeServiceCounts()
                        },
                        matchIsOver: matchIsOver
                    )
                }
                
                // Chrono and Set Management
                VStack(spacing: 10) {
                    Button(action: startCountdown) {
                        Text("Start Chrono")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    Button(action: startCountdown) {
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
            }
            .padding()
        }
        .sheet(isPresented: $showCountdownPopup, onDismiss: stopCountdown) {
            CountdownPopup(countdownTime: $countdownTime, onDismiss: stopCountdown)
        }
        .onAppear() {
            initializeServiceCounts()
        }
    }
    
    func onGoal(isPlayerOneScored: Bool) {
        print(matchModel)
        if isPlayerOneScored {
            pointsPlayerOne += 2
            if pointsPlayerOne >= matchModel?.numberOfPoints ?? 11 {
                if pointsPlayerOne - pointsPlayerTwo >= 2 {
                    setWinPlayerOne += 1
                    if setWinPlayerOne == (Int((Double(matchModel?.numberOfSet ?? 3) / 2) + 0.5)) {
                        print("match is over")
                    } else {
                        startCountdown()
                        pointsPlayerOne = 0
                        pointsPlayerTwo = 0
                    }
                }
            }
        } else {
            pointsPlayerTwo += 2
            if pointsPlayerTwo >= matchModel?.numberOfPoints ?? 11 {
                if pointsPlayerTwo - pointsPlayerOne >= 2 {
                    setWinPlayerTwo += 1
                    if setWinPlayerTwo == (Int((Double(matchModel?.numberOfSet ?? 3) / 2) + 0.5)) {
                        print("match is over")
                    } else {
                        startCountdown()
                        pointsPlayerOne = 0
                        pointsPlayerTwo = 0
                    }
                }
            }
        }
    }

    func onServe(isPlayerOne: Bool) {
        if isPlayerOneServe {
            if numberOfServicePlayerOne < matchModel?.numberOfService ?? 0 {
                numberOfServicePlayerOne += 1
            } else {
                numberOfServicePlayerOne = 0
                numberOfServicePlayerTwo = 1
                isPlayerOneServe = false
            }
        } else {
            if numberOfServicePlayerTwo < matchModel?.numberOfService ?? 0 {
                numberOfServicePlayerTwo += 1
            } else {
                numberOfServicePlayerTwo = 0
                numberOfServicePlayerOne = 1
                isPlayerOneServe = true
            }
        }
    }
    
    func startCountdown() {
        countdownTime = 60
        showCountdownPopup = true
        startCountdownTimer()
    }
        
    func stopCountdown() {
        countdownTimer?.invalidate()
        countdownTimer = nil
        showCountdownPopup = false
    }
    
    func initializeServiceCounts() {
        if let matchModel = matchModel, matchModel.playerOneFirstServe {
            numberOfServicePlayerOne = 0
            numberOfServicePlayerTwo = 1
        } else {
            numberOfServicePlayerOne = 0
            numberOfServicePlayerTwo = 1
        }
    }
    
    func startCountdownTimer() {
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if countdownTime > 0 {
                countdownTime -= 1
            } else {
                stopCountdown()
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
    var startCountdown: () -> Void
    var initializeFirstServe : () -> Void
    @State var timeOutButtonIsDisabled: Bool = false
    @State var matchIsOver: Bool
    
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
                    startCountdown()
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
            .onAppear(
                perform: initializeFirstServe
            )
            
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
            .disabled(matchIsOver)
            
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
            .disabled(matchIsOver)
        }
        .frame(maxWidth: .infinity)
    }
}

struct CountdownPopup: View {
    @Binding var countdownTime: Int
    var onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5).ignoresSafeArea()
            
            VStack {
                Text("Countdown")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
                
                Text("\(countdownTime)")
                    .font(.system(size: 48))
                    .foregroundColor(.white)
                    .padding()
                
                Button(action: onDismiss) {
                    Text("Dismiss")
                        .frame(minWidth: 100, minHeight: 40)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.top, 10)
                }
            }
            .frame(width: 200, height: 200)
            .background(Color.black.opacity(0.8))
            .cornerRadius(20)
        }
    }
}

#Preview {
    MatchView()
}
