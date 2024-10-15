//
//  Home.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 11/10/2024.
//

import SwiftUI

struct Home: View {
    var body: some View {
        ZStack {
            Color.red.opacity(0.3)
                .ignoresSafeArea()
            VStack {
                Text("Player One")
                
                TextField("Player one name", text: .constant(""))
                    .background(.white)
                    .padding()
                    .textFieldStyle(.roundedBorder)
                
                Text("Player Two")
                
                TextField("Player two name", text: .constant(""))
                    .background(.white)
                    .padding()
                    .textFieldStyle(.roundedBorder)
                
                Text("Best Of")
                
                Picker(selection: .constant(1), label: Text("Best Of")) {
                    Text("1").tag(1)
                    Text("3").tag(2)
                    Text("5").tag(3)
                    Text("Team").tag(4)
                    Text("Custom").tag(5)
                }
                .pickerStyle(.segmented)
                .padding()
            }
        }
    }
}

#Preview {
    Home()
}
