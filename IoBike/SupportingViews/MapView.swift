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
    let targetLocation : CLLocationCoordinate2D
    
    let locationManager = CLLocationManager()
    let view = MKMapView(frame: .zero)
    
    func makeUIView(context: Context) -> MKMapView {
        view.delegate = context.coordinator
        return view
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        let lat = targetLocation.latitude
        let long = targetLocation.longitude
        let shiftedBikeLocation = CLLocationCoordinate2D(latitude: lat - 0.009 / 4, longitude: long)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009)
        let region = MKCoordinateRegion(center: shiftedBikeLocation, span: span)
        
        view.setRegion(region, animated: true)
        
        let bike = BikeAnnotation(coordinate: targetLocation)
        view.addAnnotation(bike)
        
        view.register(BikeMarkerView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
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
        MapView(targetLocation: CLLocationCoordinate2D())
    }
}
