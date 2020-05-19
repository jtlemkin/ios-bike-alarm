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
struct UserDefaultsBackedDeviceStorage {
    unowned let device: Device
    
    var index: Int = UserDefaults.standard.integer(forKey: "currentBikeIndex") {
        didSet {
            UserDefaults.standard.set(index, forKey: "currentBikeIndex")
            
            device.syncStateWithStorage()
        }
    }
    
    var isArmed: Bool {
        return UserDefaults.standard.bool(forKey: "isArmed\(index)")
    }
    
    var lastKnownLocation: CLLocationCoordinate2D {
        let latitude = UserDefaults.standard.double(forKey: "latitude\(index)")
        let longitude = UserDefaults.standard.double(forKey: "longitude\(index)")
        
        if latitude == 0.0 && longitude == 0.0 {
            return CLLocationManager().location?.coordinate ??
                CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
        } else {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
    
    var name: String? {
        return UserDefaults.standard.string(forKey: "name\(index)")
    }
    
    var batteryLife: Double {
        return UserDefaults.standard.double(forKey: "batteryLife\(index)")
    }
    
    mutating func register(withName name: String, withID id: String) {
        guard index < 3 else {
            //Bring index back down to index of last device
            index -= 1
            return
        }
        
        if self.name == nil {
            UserDefaults.standard.set(name, forKey: "name\(index)")
            UserDefaults.standard.set(id, forKey: "id\(index)")
            device.name = name
        } else {
            index += 1
            register(withName: name, withID: id)
        }
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
    
    static func getAllDeviceIDs() -> [String] {
        var ids = [String]()
        
        for i in 0..<3 {
            if let id = UserDefaults.standard.string(forKey: "id\(i)") {
                ids.append(id)
            }
        }
        
        return ids
    }
}
