//
//  SceneDelegate.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 24/01/2025.
//

import UIKit
import SwiftUI

/// The `SceneDelegate` class is responsible for managing the lifecycle of the app's window scene. It sets up the initial view of the app and handles global gestures.
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    /// Called when a new scene is being created and connected to the app.
    /// - Parameters:
    ///   - scene: The `UIScene` object representing the app's current user interface environment.
    ///   - session: The `UISceneSession` object containing configuration information for the scene.
    ///   - connectionOptions: Additional options for configuring the connection.
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let contentView = ContentView()

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            
            window.rootViewController = UIHostingController(rootView: contentView)
            
            self.window = window
            window.makeKeyAndVisible()

            let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
            tapGesture.cancelsTouchesInView = false // Ensure other gestures (like button taps) still work.
            tapGesture.delegate = self
            tapGesture.name = "DissmissKeyboard" // Optional: Name the gesture recognizer for debugging purposes.
            
            window.addGestureRecognizer(tapGesture)
        }
    }
}

extension SceneDelegate: UIGestureRecognizerDelegate {
    /// Determines whether the gesture recognizer should recognize gestures simultaneously with another gesture recognizer.
    /// - Parameters:
    ///   - gestureRecognizer: The current gesture recognizer.
    ///   - otherGestureRecognizer: Another gesture recognizer.
    /// - Returns: A Boolean value indicating whether gestures should be recognized simultaneously. Defaults to `false`.
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}
