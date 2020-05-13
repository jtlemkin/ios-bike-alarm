//
//  UserPreferencesBackedDeviceStorage.swift
//  IoBike
//
//  Created by James Lemkin on 5/12/20.
//  Copyright © 2020 James Lemkin. All rights reserved.
//

import Foundation
import CoreLocation

/*
    This class allows easy reading and writing to user preferences based on the
    currently selected bike
 */
struct UserPreferencesBackedDeviceStorage {
    unowned let device: Device
    let index: Int
    
    var isArmed: Bool {
        return UserDefaults.standard.bool(forKey: "isArmed\(index)")
    }
    
    var lastKnownLocation: CLLocationCoordinate2D {
        let latitude = UserDefaults.standard.double(forKey: "latitude\(index)")
        let longitude = UserDefaults.standard.double(forKey: "longitude\(index)")
        
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var name: String {
        return UserDefaults.standard.string(forKey: "name\(index)") ?? "Bike\(index)"
    }
    
    func update(isArmed: Bool) {
        UserDefaults.standard.set(isArmed, forKey: "isArmed\(index)")
        device.isArmed = isArmed
    }
    
    // Records current battery life in user preferences
    func update(batteryLife: Data?) {
        if let batteryLife = batteryLife {
            UserDefaults.standard.set(Int.from(data: batteryLife),
                                      forKey: "batteryLife\(index)")
        }
    }
    
    func saveCurrentLocation() {
        let currentCoordinates = CLLocationManager().location!.coordinate
        
        UserDefaults.standard.set(currentCoordinates.latitude, forKey: "latitude\(index)")
        UserDefaults.standard.set(currentCoordinates.longitude, forKey: "longitude\(index)")
        
        device.lastKnownLocation = currentCoordinates
    }
}