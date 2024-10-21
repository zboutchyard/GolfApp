//
//  CourseSearchViewModel.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 12/24/23.
//

import Foundation
import MapKit

class CourseSearchViewModel: NSObject, ObservableObject, MKLocalSearchCompleterDelegate, CLLocationManagerDelegate {
    @Published var locationResult: [GolfCourse] = []
    @Published var currentLocation: CLLocation?
    @Published var state: GolfCourseLoadingState = .loading
    let completer = MKLocalSearchCompleter()
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        completer.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.first
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func searchForGolfCourses(near location: CLLocation) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "golf course"
        request.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            guard let response = response, error == nil else {
                print("Search error: \(error?.localizedDescription ?? "Unknown error")")
                self.state = .error
                return
            }
            let golfCourses = response.mapItems.compactMap { item -> GolfCourse? in
                guard let name = item.name, let address = item.placemark.title else { return nil }
                return GolfCourse(name: name, address: address)
            }
            DispatchQueue.main.async {
                self.locationResult = golfCourses
                self.state = .loaded
            }
        }
    }
}
