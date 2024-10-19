//
//  CounterView.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 17/10/2024.
//

import SwiftUI

struct CounterView: View {
    @State var bestOfSelectedPicker: Int = 0
    @State var numberOfSetInt: Int = 1
    @State var pointsPerSetInt: Int = 11
    @State var numberOfServiceInt: Int = 2
    @State var changeSide: Bool = true
    
    var body: some View {
        VStack(spacing: 20) {
            counterView(title: "Number of Sets", value: $numberOfSetInt, isDisabled: bestOfSelectedPicker != 4)
            counterView(title: "Points per Set", value: $pointsPerSetInt, isDisabled: bestOfSelectedPicker != 4)
            counterView(title: "Number of Service", value: $numberOfServiceInt, isDisabled: bestOfSelectedPicker != 4)

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
        .onChange(of: bestOfSelectedPicker, perform: { newValue in
            updateDefaults(for: newValue)
        })
    }

    // Fonction de mise à jour des valeurs par défaut selon le sélecteur "Best Of"
    private func updateDefaults(for selection: Int) {
        switch selection {
        case 0: // Best of 1
            numberOfSetInt = 1
            pointsPerSetInt = 11
            numberOfServiceInt = 2
        case 1: // Best of 3
            numberOfSetInt = 3
            pointsPerSetInt = 11
            numberOfServiceInt = 2
        case 2: // Best of 5
            numberOfSetInt = 5
            pointsPerSetInt = 11
            numberOfServiceInt = 2
        case 3: // Team
            numberOfSetInt = 1
            pointsPerSetInt = 31
            numberOfServiceInt = 3
        case 4: // Custom
            // Ne pas modifier les valeurs, laisser l'utilisateur choisir
            break
        default:
            break
        }
    }

    // Fonction pour créer un compteur réutilisable
    @ViewBuilder
    private func counterView(title: String, value: Binding<Int>, isDisabled: Bool) -> some View {
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
                .disabled(isDisabled)
                
                Text("\(value.wrappedValue)")
                    .font(.title2)
                    .padding()
                    .frame(minWidth: 75)
                
                Button(action: {
                    value.wrappedValue += 1
                }) {
                    Image(systemName: "arrowshape.right")
                        .font(.title)
                        .padding()
                }
                .disabled(isDisabled)
            }
            .padding(.trailing)
        }
    }
}

#Preview {
    CounterView()
}
