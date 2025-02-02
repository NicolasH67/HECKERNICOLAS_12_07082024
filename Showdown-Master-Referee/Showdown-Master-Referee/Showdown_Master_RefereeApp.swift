//
//  Showdown_Master_RefereeApp.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 11/10/2024.
//

import SwiftUI

@main
struct Showdown_Master_RefereeApp: App {
    
    @UIApplicationDelegateAdaptor var appDelegate: AppDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
        }
    }
}
