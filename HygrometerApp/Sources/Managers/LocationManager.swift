import CoreLocation
import Foundation


class LocationManager: NSObject {
    
    private override init() { }
    
    static let shared = LocationManager()
    
    private let manager = CLLocationManager()
    
    private var completion: ((CLLocation) -> Void)?
    
    /// 사용자의 위치정보를 설정합니다.
    public func userLocation(completion: @escaping (CLLocation) -> Void) {
        manager.requestWhenInUseAuthorization()
        self.completion = completion
        manager.delegate = self
        manager.startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        manager.stopUpdatingLocation()
        manager.delegate = nil
        completion?(location)
    }
}
