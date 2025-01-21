//
//  ScoreBoxView.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 21/11/2024.
//

import SwiftUI

struct ScoreBoxView: View {
    var title: String
    var value: Int

    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
                .padding(.bottom, 4)

            Text("\(value)")
                .font(.system(size: dynamicFontSize()))
                .fontWeight(.semibold)
                .frame(width: dynamicWidth(), height: dynamicHeight())
                .background(Color.white.opacity(0.7))
                .cornerRadius(6)
                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                .foregroundColor(.blue)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.7), lineWidth: 2)
                )
        }
    }

    private func dynamicFontSize() -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        if screenWidth > 375 {
            return 23
        } else {
            return 15
        }
    }

    private func dynamicWidth() -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        return min(screenWidth * 0.25, 40)
    }

    // Hauteur fixe
    private func dynamicHeight() -> CGFloat {
        return 40
    }
}

struct ScoreBoxContainerView: View {
    var body: some View {
        HStack(spacing: 20) {
            ScoreBoxView(title: "Score 1", value: 10)
            ScoreBoxView(title: "Score 2", value: 5)
            Spacer()
            ScoreBoxView(title: "Score 3", value: 3)
            ScoreBoxView(title: "Score 4", value: 8)
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.vertical, 20)
    }
}

#Preview {
    ScoreBoxContainerView()
}
