//
//  StartGameButton.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 04/12/2024.
//

import SwiftUI
import FirebaseAnalytics

/// A custom button used to start the game. It displays a gradient background with a play icon
/// and a label indicating "Start Game". The button has an action closure that is triggered
/// when the button is tapped.
///
/// The button uses a `ZStack` to layer the background gradient, a `HStack` for the icon and text,
/// and applies a shadow for a raised effect. The gradient consists of two colors, "Deep Purple"
/// and "Raspberry Pink", which are visually appealing and aligned with the app's theme. The
/// button’s shadow gives it a floating effect, making it visually prominent.
///
/// This view requires an `action` closure parameter, which is invoked when the button is pressed.
struct StartGameButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            Analytics.logEvent(
                "start_game_button_clicked",
                parameters: ["timestamp": Date().timeIntervalSince1970]
            )
            action()
        }) {
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
                    Text("Start Game")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .padding()
            }
        }
        .padding(.horizontal)
    }
}
