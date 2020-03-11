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
    @ObservedObject var bluetoothController: BluetoothController
    
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
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        let locationManager = CLLocationManager()
        
        init(_ parent: MapView) {
            self.parent = parent
            super.init()
            
            parent.view.showsUserLocation = true
            
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            
            self.parent.view.register(BikeMarkerView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
            
            self.showUserLocation()
            self.showBikeLocation()
        }
        
        /*func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let annotation = annotation as? Bike else { return nil }
            
            let identifier = "marker"
            var view: MKMarkerAnnotationView
            
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
            }
            
            return view
        }*/
        
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
        
        func showBikeLocation() {
            if let bikeLocation = parent.bluetoothController.lastSeenBikeLocation {
                let bike = Bike(bikeLocation)
                
                parent.view.addAnnotation(bike)
            } else {
                let bike = Bike(CLLocationCoordinate2D(latitude: 21.283921, longitude: -157.831661))
                
                parent.view.addAnnotation(bike)
            }
        }
    }
    
    class Bike: NSObject, MKAnnotation {
        var coordinate: CLLocationCoordinate2D
        
        init(_ coordinate: CLLocationCoordinate2D) {
            self.coordinate = coordinate
            
            super.init()
        }
    }
    
    class BikeMarkerView: MKMarkerAnnotationView {
        override var annotation: MKAnnotation?  {
            willSet {
                guard let _ = newValue as? Bike else { return }
                
                markerTintColor = .white
                glyphText = String("🚲")
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(bluetoothController: BluetoothController())
    }
}
