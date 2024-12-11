//
//  PlayerActionView.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 21/11/2024.
//

import SwiftUI

struct PlayerActionView: View {
    var totalService: Int
    var currentService: Int
    var onGoal: () -> Void
    var onFault: () -> Void
    var onServe: () -> Void
    var startCountdown: () -> Void
    var initializeFirstServe : () -> Void
    @Binding var timeOutButtonIsDisabled: Bool
    @State var matchIsOver: Bool
    
    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 2) {
                Button(action: {}) {
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
                .foregroundColor(.gray)
            
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
                    .background(Color("Deep Purple"))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity)
            }
            .disabled(matchIsOver)
        }
        .frame(maxWidth: .infinity)
    }
}
