//
//  Home.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 11/10/2024.
//

import SwiftUI

struct Home: View {
    @State var bestOfSelectedPicker: Int = 0
    @State var playerOneName: String = ""
    @State var playerTwoName: String = ""
    @State var numberOfSetInt: Int = 0
    @State var pointsPerSetInt: Int = 0
    @State var numberOfServiceInt: Int = 0
    @State var changeSide: Bool = true
    @State var firstServeSelectedPicker: Int = 0
    let pickerBestOfLabels: [String] = ["1", "3", "5", "Team", "Custom"]
    let pickerFirstServeLabels: [String] = ["Player One", "Player Two"]

    var body: some View {
        ZStack {
            Color.red.opacity(0.3)
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 15) {
                Group {
                    Text("Player One")
                        .font(.headline)
                        .padding(.leading)
                    
                    TextField("Player one name", text: $playerOneName)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                }

                Group {
                    Text("Player Two")
                        .font(.headline)
                        .padding(.leading)

                    TextField("Player two name", text: $playerTwoName)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                }

                Text("Best Of")
                    .font(.headline)
                    .padding(.leading)

                Picker(selection: $bestOfSelectedPicker, label: Text("Best Of")) {
                    ForEach(0 ..< pickerBestOfLabels.count, id: \.self) { index in
                        Text(pickerBestOfLabels[index]).tag(index)
                    }
                }
                .pickerStyle(.segmented)
                .padding()

                Divider()

                VStack(spacing: 20) {
                    counterView(title: "Number of Sets", value: $numberOfSetInt)
                    counterView(title: "Points per Set", value: $pointsPerSetInt)
                    counterView(title: "Number of Service", value: $numberOfServiceInt)

                    // Change Side Toggle
                    HStack {
                        Text("Change Side")
                            .font(.headline)
                            .padding(.leading)
                        Toggle("", isOn: $changeSide)
                            .labelsHidden()
                    }
                    .padding(.horizontal)
                }

                // First Serve Picker
                Text("First Serve")
                    .font(.headline)
                    .padding(.leading)

                Picker(selection: $firstServeSelectedPicker, label: Text("First Serve")) {
                    ForEach(0 ..< pickerFirstServeLabels.count, id: \.self) { index in
                        Text(pickerFirstServeLabels[index]).tag(index)
                    }
                }
                .pickerStyle(.segmented)
                .padding()

                Button(action: {
                    print("\(playerOneName) vs \(playerTwoName)")
                }) {
                    ZStack {
                        Color.blue.opacity(0.8)
                        Label("Start Game", systemImage: "play.circle")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                    }
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                .padding(.top)
            }
        }
    }
    
    @ViewBuilder
    private func counterView(title: String, value: Binding<Int>) -> some View {
        HStack {
            Text(title)
                .font(.headline)
                .padding(.leading)

            Spacer()

            HStack(spacing: 0) {
                Button(action: {
                    if value.wrappedValue > 0 {
                        value.wrappedValue -= 1
                    }
                }) {
                    Image(systemName: "arrowshape.left")
                        .font(.title)
                        .padding()
                }
                
                Text("\(value.wrappedValue)")
                    .font(.title2)
                    .padding()
                    .frame(minWidth: 50)

                Button(action: {
                    value.wrappedValue += 1
                }) {
                    Image(systemName: "arrowshape.right")
                        .font(.title)
                        .padding()
                }
            }
            .padding(.trailing)
        }
    }
}

#Preview {
    Home()
}
