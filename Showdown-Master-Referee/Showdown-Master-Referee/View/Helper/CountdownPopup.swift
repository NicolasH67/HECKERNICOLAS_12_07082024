//
//  CountdownPopup.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 21/11/2024.
//

import SwiftUI

struct CountdownPopup: View {
    @Binding var countdownTime: Int
    var playerOneName: String
    var playerTwoName: String
    var coachPlayerOneName: String
    var coachPlayerTwoName: String
    var onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            // Fond totalement transparent pour le ZStack principal
            Color.black.opacity(0.5)
                .ignoresSafeArea()
            
            // Contenu de la popup
            VStack(spacing: 20) {
                Text("Countdown")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
                
                Text("\(countdownTime)")
                    .font(.system(size: 48))
                    .foregroundColor(.white)
                    .padding()
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Player 1:")
                            .fontWeight(.bold)
                        Text(playerOneName)
                    }
                    .foregroundColor(.white)
                    
                    HStack {
                        Text("Coach:")
                            .fontWeight(.bold)
                        Text(coachPlayerOneName)
                    }
                    .foregroundColor(.white)
                    
                    Divider().background(Color.white)
                    
                    HStack {
                        Text("Player 2:")
                            .fontWeight(.bold)
                        Text(playerTwoName)
                    }
                    .foregroundColor(.white)
                    
                    HStack {
                        Text("Coach:")
                            .fontWeight(.bold)
                        Text(coachPlayerTwoName)
                    }
                    .foregroundColor(.white)
                }
                .font(.body)
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(10)
                
                Button(action: onDismiss) {
                    Text("Dismiss")
                        .frame(minWidth: 100, minHeight: 40)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.top, 10)
                }
            }
            .frame(width: 300)
            .padding()
            .background(Color.black.opacity(0.8))
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5) // Ombre pour plus de visibilité
        }
    }
}
