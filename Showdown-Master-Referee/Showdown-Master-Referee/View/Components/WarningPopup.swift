//  WarningPopup.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 23/12/2024.
//

import SwiftUI

/// Popup view for issuing a warning, penalty, or penalty related to glasses for a player.
///
/// This view allows the user to:
/// - Select a warning or penalty option.
/// - Enter a reason for the action.
/// - Confirm or cancel the operation.
///
/// - Parameters:
///   - `selectedOption`: A `Binding` to the currently selected option (e.g., "Warning", "Penalty").
///   - `reasonText`: A `String` to capture the reason for the selected option (auto-populated for "Penalty (Glasses)").
///   - `playerName`: A `String` representing the name of the player receiving the warning or penalty.
///   - `onWarning`: A closure triggered when the user confirms the action.
///   - `onDismiss`: A closure triggered when the user cancels the popup.
struct WarningPopup: View {
    @Binding var selectedOption: String?
    @State private var reasonText: String = ""
    var playerName: String
    var onWarning: () -> Void
    var onDismiss: () -> Void

    /// Body of the popup displaying a warning message, options to select, and a reason text field.
    var body: some View {
        ZStack {
            Color.red.opacity(0.3)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("Warning for \(playerName)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color("Deep Purple"))

                VStack(alignment: .leading, spacing: 15) {
                    Text("Select an Option")
                        .font(.headline)
                        .foregroundColor(Color("Raspberry Pink"))

                    VStack(alignment: .leading, spacing: 10) {
                        CheckBoxRow(title: "Warning", selectedOption: $selectedOption)
                        CheckBoxRow(title: "Penalty", selectedOption: $selectedOption)
                        CheckBoxRow(title: "Penalty (Glasses)", selectedOption: $selectedOption)
                    }
                }
                .padding()
                .background(Color.white.opacity(0.9))
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)

                Text("Reason")
                    .font(.headline)
                    .foregroundColor(Color("Deep Purple"))

                TextField("Enter reason here", text: $reasonText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)

                Button(action: {
                    onWarning()
                }) {
                    Text("Confirm")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(LinearGradient(
                            colors: [Color("Deep Purple"), Color("Raspberry Pink")],
                            startPoint: .leading,
                            endPoint: .trailing
                        ))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                }
                .padding(.top, 20)
                
                Button(action: {
                    onDismiss()
                }) {
                    Text("Cancel")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(LinearGradient(
                            colors: [Color("Deep Purple"), Color("Raspberry Pink")],
                            startPoint: .leading,
                            endPoint: .trailing
                        ))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                }
                .padding(.top, 20)
                
                Spacer()
            }
            .padding()
            .background(Color("Deep Purple").opacity(0.1))
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 10)
            .padding(.horizontal, 20)
        }
        .onChange(of: selectedOption) { _, newValue in
            if newValue == "Penalty (Glasses)" {
                reasonText = "Touching Glasses"
            } else {
                reasonText = ""
            }
        }
    }
}


struct CheckBoxRow: View {
    var title: String
    @Binding var selectedOption: String?

    var body: some View {
        Button(action: {
            selectedOption = title
        }) {
            HStack {
                Image(systemName: selectedOption == title ? "checkmark.square" : "square")
                    .foregroundColor(selectedOption == title ? Color("Raspberry Pink") : .gray)
                Text(title)
                    .foregroundColor(.black)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
