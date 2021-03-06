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
    @EnvironmentObject var device: Device
    
    let locationManager = CLLocationManager()
    let view = MKMapView(frame: .zero)
    
    func makeUIView(context: Context) -> MKMapView {
        view.delegate = context.coordinator
        return view
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        let locationToDisplay = device.lastKnownLocation ?? CLLocationManager().location?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)
        let lat = locationToDisplay.latitude
        let long = locationToDisplay.longitude

        let shiftedBikeLocation = CLLocationCoordinate2D(latitude: lat - 0.009 / 3, longitude: long)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009)
        let region = MKCoordinateRegion(center: shiftedBikeLocation, span: span)
        
        view.setRegion(region, animated: true)
        
        if let bikeLocation = device.lastKnownLocation {
            view.addAnnotation(BikeAnnotation(coordinate: bikeLocation))
        }
        
        view.register(BikeMarkerView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
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
            
            locationManager.delegate = self
            
            parent.view.showsUserLocation = true
            
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                parent.device.syncStateWithStorage()
            default:
                break
            }
        }
    }
    
    class BikeAnnotation: NSObject, MKAnnotation {
        var coordinate: CLLocationCoordinate2D
        
        init(coordinate: CLLocationCoordinate2D) {
            self.coordinate = coordinate
            
            super.init()
        }
    }
    
    class BikeMarkerView: MKMarkerAnnotationView {
        override var annotation: MKAnnotation?  {
            willSet {
                guard let _ = newValue as? BikeAnnotation else { return }
                
                markerTintColor = .white
                glyphText = String("🚲")
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
