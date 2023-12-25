//
//  CourseSearchViewModel.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 12/24/23.
//

import Foundation
import MapKit

class CourseSearchViewModel: NSObject, ObservableObject, MKLocalSearchCompleterDelegate, CLLocationManagerDelegate {
    @Published var locationResult: [MKLocalSearchCompletion] = []
    
    
    let completer = MKLocalSearchCompleter()
    @Published var currentLocation: CLLocation?
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        completer.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        let nonSpecificTerms = ["golf course", "golf courses"]
        locationResult = completer.results.filter { completion in
            !nonSpecificTerms.contains(completion.title.lowercased())
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.first
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    func fetchGolfCourseDetails(for completion: MKLocalSearchCompletion) {
        let request = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: request)
        
        search.start { (response, error) in
            guard let response = response, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            for item in response.mapItems {
                // Process the detailed information about each golf course
                // For example, you could create GolfCourse objects and add them to an array
            }
        }
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func searchForGolfCourses(near location: CLLocation) {
        completer.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        completer.queryFragment = "Golf Course near me"
        completer.resultTypes = .query
    }
}
