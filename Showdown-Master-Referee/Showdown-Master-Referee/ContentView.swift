//
//  ContentView.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 11/10/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var matchGestion = MatchGestion()
    @State private var selection: Tab = .featured
    
    enum Tab {
        case featured
        case list
    }
    
    var body: some View {
        TabView(selection: $selection) {
            LocalHomeView()
                .tabItem{
                    Label("Local", systemImage: "house")
                }
                .tag(Tab.featured)
                .environmentObject(matchGestion)
            NetworkConnexionView()
                .tabItem{
                    Label("Network", systemImage: "network")
                }
                .tag(Tab.list)
                .environmentObject(matchGestion)
        }
    }
}

#Preview {
    ContentView()
}
