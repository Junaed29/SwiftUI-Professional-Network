// OnboardingModel.swift
//  ProfessionalNetworkingApp
//
//  Created by Junaed Chowdhury on 18/8/25.
//

import Foundation

struct OnboardingDataModel {
    var lottieFile: String
    var heading: String
    var text: String
}

extension OnboardingDataModel {
    static var compactData: [OnboardingDataModel] = [
        OnboardingDataModel(
            lottieFile: "network_connections_minimal",
            heading: "Connect Professionally",
            text: "Build verified business relationships with professionals in your field."
        ),
        OnboardingDataModel(
            lottieFile: "smart_matching_simple",
            heading: "Smart Matching",
            text: "Find compatible professionals based on location, industry, and career goals."
        ),
        OnboardingDataModel(
            lottieFile: "secure_chat_animation",
            heading: "Private Messaging",
            text: "Chat securely and share documents with your professional matches."
        ),
    ]
}
