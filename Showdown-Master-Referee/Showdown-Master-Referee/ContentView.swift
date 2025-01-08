//
//  ContentView.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 11/10/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var selection: Tab = .featured
    private var networkManager: NetworkManager = NetworkManager()
    
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
            NetworkConnexionView(networkManager: networkManager)
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
