//
//  SectionHeader.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 03/12/2024.
//

import SwiftUI

/// A simple custom view for displaying section headers with styled text and background.
/// This component is used to display titles in a consistent and visually appealing way
/// within sections of the app's user interface. It provides a bold title with some spacing
/// and a subtle background color to distinguish sections in the UI. It can be reused
/// in different sections where a header is needed to organize content.
///
/// - `title`: The text to be displayed as the header.
struct SectionHeader: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.title2.bold())
            .padding(.vertical, 5)
            .padding(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.gray.opacity(0.2))
    }
}

#Preview {
    SectionHeader(title: "Title")
}
