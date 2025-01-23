//
//  PlayerActionView.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 21/11/2024.
//

import SwiftUI

/// A view representing a player's action panel in a match.
///
/// This view provides controls for various player actions during a match, including serving, scoring a goal, committing a fault, starting a timeout, issuing a warning, and initializing the first serve. It also visually displays the current service status.
///
/// - Parameters:
///   - `totalService`: The total number of services allowed.
///   - `currentService`: The number of services completed so far.
///   - `onGoal`: A closure triggered when the "Goal" button is pressed.
///   - `onFault`: A closure triggered when the "Fault" button is pressed.
///   - `onServe`: A closure triggered when a serve action occurs.
///   - `startCountdown`: A closure triggered when the "TO" (Timeout) button is pressed.
///   - `showWarning`: A closure triggered when the "P/W" (Penalty/Warning) button is pressed.
///   - `initializeFirstServe`: A closure triggered to initialize the first serve state.
///   - `timeOutButtonIsDisabled`: A `Binding` controlling whether the timeout button is enabled or disabled.
///   - `matchIsOver`: A `State` indicating whether the match has concluded.
struct PlayerActionView: View {
    var totalService: Int
    var currentService: Int
    var onGoal: () -> Void
    var onFault: () -> Void
    var onServe: () -> Void
    var startCountdown: () -> Void
    var showWarning: () -> Void
    var initializeFirstServe : () -> Void
    @Binding var timeOutButtonIsDisabled: Bool
    @State var matchIsOver: Bool
    
    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 2) {
                Button(action: {
                    showWarning()
                }) {
                    Text("P/W")
                        .frame(minWidth: 40, minHeight: 40)
                        .padding()
                        .background(Color("Raspberry Pink"))
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
                        .background(timeOutButtonIsDisabled ? Color.gray : Color("Raspberry Pink"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(timeOutButtonIsDisabled)
            }
            
            Text("Service")
                .font(.caption)
                .foregroundColor(.black)
            
            HStack(spacing: 10) {
                ForEach(0..<totalService, id: \.self) { index in
                    Circle()
                        .strokeBorder(Color("Deep Purple"), lineWidth: 2)
                        .background(Circle().fill(index < currentService ? Color("Deep Purple") : Color.clear))
                        .frame(width: 30, height: 30)
                }
            }
            .onAppear {
                initializeFirstServe()
            }
            
            Button(action: {
                onServe()
                onGoal()
            }) {
                Text("Goal")
                    .frame(minWidth: 100, minHeight: 50)
                    .padding()
                    .background(Color("Deep Purple"))
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
                    .background(Color("Raspberry Pink"))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity)
            }
            .disabled(matchIsOver)
        }
        .frame(maxWidth: .infinity)
    }
}
