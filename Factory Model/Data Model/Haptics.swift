//
//  Haptics.swift
//  Factory Model
//
//  Created by Igor Malyarov on 19.11.2020.
//

import SwiftUI
import CoreHaptics

final class Haptics {
    
    let hapticsAvailable: Bool = CHHapticEngine.capabilitiesForHardware().supportsHaptics
    
    func haptic(style: UIImpactFeedbackGenerator.FeedbackStyle = .light) {
        if hapticsAvailable {
            let generator = UIImpactFeedbackGenerator(style: style)
            generator.impactOccurred()
        }
    }
    
    func haptic(feedback: UINotificationFeedbackGenerator.FeedbackType) {
        if hapticsAvailable {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(feedback)
        }
    }
    
}
