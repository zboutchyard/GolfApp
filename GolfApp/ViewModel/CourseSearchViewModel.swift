//
//  CourseSearchViewModel.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 12/24/23.
//

import Foundation
import MapKit

class CourseSearchViewModel: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published var locationResult: [MKLocalSearchCompletion] = []
    
    
    let completer = MKLocalSearchCompleter()
    
    override init() {
        super.init()
        completer.delegate = self
    }

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        locationResult = completer.results
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
