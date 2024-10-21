//
//  BestOf.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 17/10/2024.
//

import SwiftUI

struct BestOf: View {
    @State var bestOfSelectedPicker: Int = 0
    @State var numberOfSetInt: Int = 1
    @State var pointsPerSetInt: Int = 11
    @State var numberOfServiceInt: Int = 2
    @State var changeSide: Bool = true
    let pickerBestOfLabels: [String] = ["1", "3", "5", "Team", "Custom"]
    
    var body: some View {
        VStack(alignment: .leading) {
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

            // Compteurs pour les sets, points par set et services
            VStack(spacing: 0) {
                counterView(title: "Number of Sets", value: $numberOfSetInt, step: 2, isDisabled: bestOfSelectedPicker != 4)
                counterView(title: "Points per Set", value: $pointsPerSetInt, step: 2, isDisabled: bestOfSelectedPicker != 4)
                counterView(title: "Number of Service", value: $numberOfServiceInt, step: 1, isDisabled: bestOfSelectedPicker != 4)

                // Toggle pour changer de côté
                HStack {
                    Text("Change Side")
                        .font(.headline)
                        .padding(.leading)
                    Toggle("", isOn: $changeSide)
                        .labelsHidden()
                        .disabled(bestOfSelectedPicker != 4) // Désactiver si pas en "Custom"
                }
                .padding(.horizontal)
            }
            .onAppear {
                updateDefaults(for: bestOfSelectedPicker) // Mise à jour des valeurs par défaut au chargement
            }
            .onChange(of: bestOfSelectedPicker) { newValue in
                updateDefaults(for: newValue) // Mise à jour lorsque la sélection change
            }
        }
    }

    // Fonction de mise à jour des valeurs par défaut selon le sélecteur "Best Of"
    private func updateDefaults(for selection: Int) {
        switch selection {
        case 0: // Best of 1
            numberOfSetInt = 1
            pointsPerSetInt = 11
            numberOfServiceInt = 2
            changeSide = true
        case 1: // Best of 3
            numberOfSetInt = 3
            pointsPerSetInt = 11
            numberOfServiceInt = 2
            changeSide = true
        case 2: // Best of 5
            numberOfSetInt = 5
            pointsPerSetInt = 11
            numberOfServiceInt = 2
            changeSide = true
        case 3: // Team
            numberOfSetInt = 1
            pointsPerSetInt = 31
            numberOfServiceInt = 3
            changeSide = true
        case 4: // Custom
            // Ne pas modifier les valeurs, laisser l'utilisateur choisir
            break
        default:
            break
        }
    }

    // Fonction pour créer un compteur réutilisable avec des pas différents
    @ViewBuilder
    private func counterView(title: String, value: Binding<Int>, step: Int, isDisabled: Bool) -> some View {
        HStack {
            Text(title)
                .font(.headline)
                .padding(.leading)
            
            Spacer()
            
            HStack(spacing: 0) {
                Button(action: {
                    if value.wrappedValue >= step { // Vérifier si la valeur est au moins égale au pas
                        value.wrappedValue -= step
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
                    value.wrappedValue += step
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
    BestOf()
}
