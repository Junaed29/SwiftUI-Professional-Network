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
            lottieFile: "career_growth_animation",
            heading: "Grow Your Career",
            text: "Access opportunities, mentorship, and resources tailored to your professional journey."
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
