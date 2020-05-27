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
    
    var id: String? {
        return UserDefaults.standard.string(forKey: "id\(index)")
    }
    
    var batteryLife: Int {
        return UserDefaults.standard.integer(forKey: "batteryLife\(index)")
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
    func update(batteryLife: Int) {
        UserDefaults.standard.set(batteryLife, forKey: "batteryLife\(index)")
        device.batteryLife = self.batteryLife
    }
    
    func saveCurrentLocation() {
        if let currentLocation = CLLocationManager().location {
            let coordinate = currentLocation.coordinate
            
            UserDefaults.standard.set(coordinate.latitude, forKey: "latitude\(index)")
            UserDefaults.standard.set(coordinate.longitude, forKey: "longitude\(index)")
            
            device.lastKnownLocation = coordinate
        }
    }
    
    mutating func swap() {
        index += 1
        
        if self.name == nil {
            index = 0
        }
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
    
    static func getAllDeviceNames() -> [String] {
        var names = [String]()
        
        for i in 0..<3 {
            if let id = UserDefaults.standard.string(forKey: "name\(i)") {
                names.append(id)
            }
        }
        
        return names
    }
    
    static func getUUIDForDevice(withName name: String) -> String? {
        for i in 0..<3 {
            if let storedName = UserDefaults.standard.string(forKey: "name\(i)") {
                if storedName == name, let id = UserDefaults.standard.string(forKey: "id\(i)") {
                    return "19b10000-\(id)-537e-4f6c-d104768a1214"
                }
            }
        }
        
        return nil
    }
}
