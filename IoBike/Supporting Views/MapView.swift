//
//  MapView.swift
//  IoBike
//
//  Created by James Lemkin on 3/9/20.
//  Copyright © 2020 James Lemkin. All rights reserved.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    var coordinate: CLLocationCoordinate2D
    let locationManager = CLLocationManager()
    let view = MKMapView(frame: .zero)
    
    func makeUIView(context: Context) -> MKMapView {
        view.delegate = context.coordinator
        return view
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
    }
    
    func makeCoordinator() -> MapView.Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate, CLLocationManagerDelegate {
        var parent: MapView
        let locationManager = CLLocationManager()
        
        init(_ parent: MapView) {
            self.parent = parent
            super.init()
            
            parent.view.showsUserLocation = true
            
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            
            self.showUserLocation()
        }
        
        func showUserLocation() {
            let status = CLLocationManager.authorizationStatus()
            
            if status == .authorizedAlways || status == .authorizedWhenInUse {
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
                let location = locationManager.location!.coordinate
                let span = MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009)
                let region = MKCoordinateRegion(center: location, span: span)
                parent.view.setRegion(region, animated: true)
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0))
    }
}
