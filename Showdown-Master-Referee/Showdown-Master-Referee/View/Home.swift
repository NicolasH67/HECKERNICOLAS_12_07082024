//
//  Home.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 11/10/2024.
//

import SwiftUI

struct Home: View {
    @State var selectedPicker: Int = 0
    @State var playerOneName: String = ""
    @State var playerTwoName: String = ""
    @State var numberOfSetInt: Int = 0
    @State var pointsPerSetInt: Int = 0
    @State var numberOfServiceInt: Int = 0
    @State var changeSide: Bool = true
    let pickerLabels: [String] = ["1","3", "5", "Team", "Custom"]
    var body: some View {
        ZStack {
            Color.red.opacity(0.3)
                .ignoresSafeArea()
            VStack {
                Text("Player One")
                
                TextField("Player one name", text: $playerOneName)
                    .textFieldStyle(.roundedBorder)
                    .background(.white)
                    .padding()
                
                Text("Player Two")
                
                TextField("Player two name", text: $playerTwoName)
                    .textFieldStyle(.roundedBorder)
                    .background(.white)
                    .padding()
                
                Text("Best Of")
                
                Picker(selection: $selectedPicker, label: Text("Best Of")) {
                    ForEach(0 ..< pickerLabels.count, id: \.self) { index in
                        Text(pickerLabels[index]).tag(index)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                
                Divider()
                
                HStack {
                    Text("Number of Sets")
                        .font(.headline)
                    
                    HStack {
                        Button(action: {
                            if numberOfSetInt > 0 { // Limiter la valeur à un minimum de 0
                                numberOfSetInt -= 1
                            }
                        }) {
                            Image(systemName: "arrowshape.left") // Icône pour "down"
                                .font(.title)
                                .padding()
                        }
                        
                        Text("\(numberOfSetInt)")
                            .font(.title2)
                            .padding()
                        
                        Button(action: {
                            numberOfSetInt += 1 // Incrémenter la valeur
                        }) {
                            Image(systemName: "arrowshape.right") // Icône pour "up"
                                .font(.title)
                                .padding()
                        }
                    }
                }
                
                HStack {
                    Text("Points per Set")
                        .font(.headline)
                    
                    HStack {
                        Button(action: {
                            if pointsPerSetInt > 0 {
                                pointsPerSetInt -= 1
                            }
                        }) {
                            Image(systemName: "arrowshape.left")
                                .font(.title)
                                .padding()
                        }
                        
                        Text("\(pointsPerSetInt)")
                            .font(.title2)
                            .padding()
                        
                        Button(action: {
                            pointsPerSetInt += 1
                        }) {
                            Image(systemName: "arrowshape.right")
                                .font(.title)
                                .padding()
                        }
                    }
                }
                
                HStack {
                    Text("Number of Service")
                        .font(.headline)
                    
                    HStack {
                        Button(action: {
                            if numberOfServiceInt > 0 {
                                numberOfServiceInt -= 1
                            }
                        }) {
                            Image(systemName: "arrowshape.left")
                                .font(.title)
                                .padding()
                        }
                        
                        Text("\(numberOfServiceInt)")
                            .font(.title2)
                            .padding()
                        
                        Button(action: {
                            numberOfServiceInt += 1
                        }) {
                            Image(systemName: "arrowshape.right")
                                .font(.title)
                                .padding()
                        }
                    }
                }
                
                HStack {
                    Text("Change Side")
                        .font(.headline)
                    
                    Toggle(isOn: $changeSide) {
                    
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    Home()
}
