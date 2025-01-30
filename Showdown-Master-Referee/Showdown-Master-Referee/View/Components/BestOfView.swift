//
//  BestOfView.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 17/10/2024.
//

import SwiftUI


/// A view for configuring match parameters based on a "Best Of" format.
///
/// This view allows users to select a predefined "Best Of" format or customize the match settings such as:
/// - Number of sets
/// - Points per set
/// - Number of services
/// - Whether players change sides during the match.
///
/// - Parameters:
///   - `bestOfSelectedPicker`: A `Binding` representing the selected index in the "Best Of" picker.
///   - `numberOfSetInt`: A `Binding` representing the number of sets for the match.
///   - `pointsPerSetInt`: A `Binding` representing the number of points required to win a set.
///   - `numberOfServiceInt`: A `Binding` representing the number of services per player per turn.
///   - `changeSide`: A `Binding` controlling whether players switch sides during the match.
///
/// - Features:
///   - The picker provides predefined formats for "Best Of" (e.g., Best of 1, 3, 5).
///   - A "Custom" option enables users to manually adjust match settings.
///   - Dynamic UI behavior disables counters and toggles unless the "Custom" option is selected.
struct BestOfView: View {
    @Binding var bestOfSelectedPicker: Int
    @Binding var numberOfSetInt: Int
    @Binding var pointsPerSetInt: Int
    @Binding var numberOfServiceInt: Int
    @Binding var changeSide: Bool
    
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

            VStack(spacing: 0) {
                counterView(title: "Number of Sets", value: $numberOfSetInt, step: 2, isDisabled: bestOfSelectedPicker != 4)
                counterView(title: "Points per Set", value: $pointsPerSetInt, step: 2, isDisabled: bestOfSelectedPicker != 4)
                counterView(title: "Number of Service", value: $numberOfServiceInt, step: 1, isDisabled: bestOfSelectedPicker != 4)

                HStack {
                    Text("Change Side")
                        .font(.headline)
                        .padding(.leading)
                    Toggle("", isOn: $changeSide)
                        .labelsHidden()
                        .disabled(bestOfSelectedPicker != 4)
                }
                .padding(.horizontal)
            }
            .onAppear {
                updateDefaults(for: bestOfSelectedPicker)
            }
            .onChange(of: bestOfSelectedPicker) { _,newValue in
                updateDefaults(for: newValue)
            }
        }
    }

    private func updateDefaults(for selection: Int) {
        switch selection {
        case 0:
            numberOfSetInt = 1
            pointsPerSetInt = 11
            numberOfServiceInt = 2
            changeSide = true
        case 1:
            numberOfSetInt = 3
            pointsPerSetInt = 11
            numberOfServiceInt = 2
            changeSide = true
        case 2:
            numberOfSetInt = 5
            pointsPerSetInt = 11
            numberOfServiceInt = 2
            changeSide = true
        case 3:
            numberOfSetInt = 1
            pointsPerSetInt = 31
            numberOfServiceInt = 3
            changeSide = true
        case 4:
            break
        default:
            break
        }
    }

    @ViewBuilder
    private func counterView(title: String, value: Binding<Int>, step: Int, isDisabled: Bool) -> some View {
        HStack {
            Text(title)
                .font(.headline)
                .padding(.leading)
            
            Spacer()
            
            HStack(spacing: 0) {
                Button(action: {
                    if value.wrappedValue >= step {
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
    BestOfView(
        bestOfSelectedPicker: .constant(0),
        numberOfSetInt: .constant(1),
        pointsPerSetInt: .constant(11),
        numberOfServiceInt: .constant(2),
        changeSide: .constant(true)
    )
}
