//
//  SectionHeader.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 03/12/2024.
//

import SwiftUI

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
