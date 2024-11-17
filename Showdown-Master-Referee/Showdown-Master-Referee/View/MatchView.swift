//  MatchView.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 21/10/2024.
//

import SwiftUI

struct MatchView: View {
    var matchModel: MatchModel?
    @State private var numberOfServicePlayerOne: Int = 0
    @State private var numberOfServicePlayerTwo: Int = 0
    @State private var pointsPlayerOne: Int = 0
    @State private var pointsPlayerTwo: Int = 0
    @State private var setWinPlayerOne: Int = 0
    @State private var setWinPlayerTwo: Int = 0
    @State private var isPlayerOneServe: Bool = true
    @State private var showCountdownPopup = false
    @State private var countdownTime = 60
    @State private var countdownTimer: Timer?
    @State private var matchIsOver: Bool = false
    @State private var changeSide: Bool = false
    
    var body: some View {
        ZStack {
            Color(.systemRed)
                .opacity(0.3)
                .ignoresSafeArea()

            VStack(spacing: 20) {
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
                
                HStack(spacing: 40) {
                    ScoreBox(title: "Points", value: pointsPlayerOne)
                    ScoreBox(title: "Sets", value: setWinPlayerOne)
                    Spacer()
                    ScoreBox(title: "Sets", value: setWinPlayerTwo)
                    ScoreBox(title: "Points", value: pointsPlayerTwo)
                }
                
                HStack(spacing: 40) {
                    PlayerActionView(
                        totalService: matchModel?.numberOfService ?? 0,
                        currentService: numberOfServicePlayerOne,
                        onGoal: {
                            self.onGoal(isPlayerOneScored: true)
                            print(numberOfServicePlayerOne)
                            print(numberOfServicePlayerTwo)
                        },
                        onFault: {
                            self.onFault(isPlayerOneFault: true)
                        },
                        onServe: {
                            self.onServe()
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
                            print(numberOfServicePlayerOne)
                            print(numberOfServicePlayerTwo)
                            self.onGoal(isPlayerOneScored: false)
                        },
                        onFault: {
                            self.onFault(isPlayerOneFault: false)
                        },
                        onServe: {
                            self.onServe()
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
        if matchIsOver { return }
        
        if isPlayerOneScored {
            pointsPlayerOne += 2
        } else {
            pointsPlayerTwo += 2
        }
        
        let maxPoints = matchModel?.numberOfPoints ?? 11
        let pointsDifference = abs(pointsPlayerOne - pointsPlayerTwo)
        let isLastSet = (setWinPlayerOne + setWinPlayerTwo + 1) == (matchModel?.numberOfSet ?? 3)
        let requiredSetsToWin = (matchModel?.numberOfSet ?? 3) / 2 + 1
        
        if (pointsPlayerOne >= maxPoints || pointsPlayerTwo >= maxPoints) && pointsDifference >= 2 {
            if pointsPlayerOne > pointsPlayerTwo {
                setWinPlayerOne += 1
            } else {
                setWinPlayerTwo += 1
            }
            
            if setWinPlayerOne == requiredSetsToWin || setWinPlayerTwo == requiredSetsToWin {
                matchIsOver = true
                return
            } else {
                resetSet()
            }
        }
        
        if isLastSet {
            let totalPoints: Int
            
            if isPlayerOneScored {
                totalPoints = pointsPlayerOne
            } else {
                totalPoints = pointsPlayerTwo
            }
            
            if totalPoints % (maxPoints / 2) == 0 {
                changeSide.toggle()
            }
        }
    }
    
    func onFault(isPlayerOneFault: Bool) {
        if matchIsOver { return }

        if isPlayerOneFault {
            pointsPlayerTwo += 1
        } else {
            pointsPlayerOne += 1
        }

        let maxPoints = matchModel?.numberOfPoints ?? 11
        let pointsDifference = abs(pointsPlayerOne - pointsPlayerTwo)
        let isLastSet = (setWinPlayerOne + setWinPlayerTwo + 1) == (matchModel?.numberOfSet ?? 3)
        let requiredSetsToWin = (matchModel?.numberOfSet ?? 3) / 2 + 1

        if (pointsPlayerOne >= maxPoints || pointsPlayerTwo >= maxPoints) && pointsDifference >= 2 {
            if pointsPlayerOne > pointsPlayerTwo {
                setWinPlayerOne += 1
            } else {
                setWinPlayerTwo += 1
            }

            if setWinPlayerOne == requiredSetsToWin || setWinPlayerTwo == requiredSetsToWin {
                matchIsOver = true
                return
            } else {
                resetSet()
            }
        }
        if isLastSet {
            let totalPoints = pointsPlayerOne + pointsPlayerTwo
            
            if totalPoints % (maxPoints / 2) == 0 {
                changeSide.toggle()
            }
        }
    }



    func onServe() {
        if numberOfServicePlayerOne > 0 {
            if numberOfServicePlayerOne == matchModel?.numberOfService ?? 2 {
                numberOfServicePlayerOne = 0
                numberOfServicePlayerTwo += 1
            } else {
                numberOfServicePlayerOne += 1
            }
        } else if numberOfServicePlayerTwo > 0 {
            if numberOfServicePlayerTwo == matchModel?.numberOfService ?? 2 {
                numberOfServicePlayerOne += 1
                numberOfServicePlayerTwo = 0
            } else {
                numberOfServicePlayerTwo += 1
            }
        }
    }
    
    func initializeServiceCounts() {
        isPlayerOneServe = matchModel?.playerOneFirstServe ?? true
        numberOfServicePlayerOne = matchModel?.playerOneFirstServe ?? true ? 1 : 0
        numberOfServicePlayerTwo = matchModel?.playerOneFirstServe ?? true ? 0 : 1
    }
    
    func resetSet() {
        print(isPlayerOneServe)
        isPlayerOneServe.toggle()
        print(isPlayerOneServe)
        
        numberOfServicePlayerOne = isPlayerOneServe ? 1 : 0
        numberOfServicePlayerTwo = isPlayerOneServe ? 0 : 1
        
        pointsPlayerOne = 0
        pointsPlayerTwo = 0
        
        startCountdown()
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
            .task {
                initializeFirstServe()
            }
            
            Button(action: {
                onServe()
                onGoal()
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
                onServe()
                onFault()
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
