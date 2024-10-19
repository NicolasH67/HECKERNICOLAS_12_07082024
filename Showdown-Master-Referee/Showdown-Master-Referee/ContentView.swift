//
//  ContentView.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 11/10/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var selection: Tab = .featured
    
    enum Tab {
        case featured
        case list
    }
    
    var body: some View {
        TabView(selection: $selection) {
            LocalHome()
                .tabItem{
                    Label("Local", systemImage: "House")
                }
                .tag(Tab.featured)
            NetworkHome()
                .tabItem{
                    Label("Network", systemImage: "network")
                }
                .tag(Tab.list)
        }
    }
}

#Preview {
    ContentView()
}
