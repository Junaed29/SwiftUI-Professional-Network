// LocationManager.swift

import Foundation
import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()

    private let manager = CLLocationManager()
    private var completion: ((CLAuthorizationStatus) -> Void)?

    private override init() { super.init(); manager.delegate = self }

    func requestWhenInUseAuthorization(completion: @escaping (CLAuthorizationStatus) -> Void) {
        self.completion = completion
        manager.requestWhenInUseAuthorization()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        completion?(manager.authorizationStatus)
        completion = nil
    }
}
