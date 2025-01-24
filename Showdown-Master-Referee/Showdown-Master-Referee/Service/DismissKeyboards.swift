//
//  DismissKeyboards.swift
//  Showdown-Master-Referee
//
//  Created by Nicolas Hecker on 24/01/2025.
//

import UIKit

/// An extension of `UIApplication` to add utility functionality for managing keyboard dismissal through a tap gesture.
extension UIApplication {
    
    /// Adds a tap gesture recognizer to the application's main window to dismiss the keyboard when tapping outside input fields.
    func addTapGestureRecognizer() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        tapGesture.name = "dismissKeyboard"
        window.addGestureRecognizer(tapGesture)
    }
}

/// Conformance of `UIApplication` to `UIGestureRecognizerDelegate` to manage gesture behaviors.
extension UIApplication: @retroactive UIGestureRecognizerDelegate {
    
    /// Specifies whether the gesture recognizer should recognize gestures simultaneously with others.
        /// - Parameters:
        ///   - gestureRecognizer: The current gesture recognizer.
        ///   - otherGestureRecognizer: Another gesture recognizer being evaluated simultaneously.
        /// - Returns: A Boolean value indicating whether gestures can be recognized simultaneously.
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}
