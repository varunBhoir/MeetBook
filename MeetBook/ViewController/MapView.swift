//
//  MapView.swift
//  MeetBook
//
//  Created by varun bhoir on 20/02/21.
//  Copyright © 2021 varun bhoir. All rights reserved.
//

import Foundation
import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    var location: Person.Location
    
    class Coordinator: NSObject, MKMapViewDelegate {
        let parent: MapView
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
            view.canShowCallout = true
            return view
        }   
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        let annotation = MKPointAnnotation()
        annotation.title = location.title
        annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(location.latitude), longitude: CLLocationDegrees(location.longitude))
        mapView.addAnnotation(annotation)

        return mapView
    }
    
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
    }
}
