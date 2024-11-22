//
//  CountdownPopup.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 21/11/2024.
//

import SwiftUI

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
