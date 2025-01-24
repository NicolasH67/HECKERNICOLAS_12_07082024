//
//  AppDelegate.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 24/01/2025.
//

import UIKit
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
            tapGesture.cancelsTouchesInView = false
            tapGesture.name = "GlobalTapGesture"
            window.addGestureRecognizer(tapGesture)
        }

        return true
    }
}
