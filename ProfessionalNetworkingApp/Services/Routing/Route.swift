//
//  Route.swift
//  ProfessionalNetworkingApp
//
//  Created by Junaed Chowdhury on 18/8/25.
//


import Foundation

/// All navigable destinations for the app.
/// Add or remove cases to match your screens.
/// Each case should carry only the data needed by the destination view.
enum Route: Hashable {
    // Auth
    case welcome
 //   case login
 //   case otpVerification(phone: String)

    // Main
    case dashboard

    // Example: pass ids or parameters as needed
    // case profileDetail(userID: String)
}
