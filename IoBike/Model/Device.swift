//
//  Device.swift
//  IoBike
//
//  Created by James Lemkin on 5/6/20.
//  Copyright © 2020 James Lemkin. All rights reserved.
//

import Foundation
import CoreBluetooth
import CoreLocation

/*
 This class reads and writes from the device. It is also responsible for saving
 the device state in user preferences.
 */
class Device: ObservableObject {
    @Published var isConnected = false
    @Published var isArmed = UserDefaults.standard.bool(forKey: "isArmed")
    @Published var lastKnownLocation = CLLocationCoordinate2D(latitude: UserDefaults.standard.double(forKey: "latitude"),
                                                              longitude: UserDefaults.standard.double(forKey: "longitude"))
    
    let serviceCBUUID = CBUUID(string: "19b10000-e8f2-537e-4f6c-d104768a1214")
    let armCharCBUUID = CBUUID(string: "19b10000-e8f2-537e-4f6c-d104768a1214")
    let batteryLifeCharCBUUID = CBUUID(string: "19b10002-e8f2-537e-4f6c-d104768a1214")
    
    //The BLE Connection Manager is responsible for setting the peripheral variable of the device
    private lazy var bleConnectionManger = BLEConnectionManager(device: self)
    
    var peripheral : CBPeripheral? {
        didSet {
            isConnected = peripheral != nil
            
            if !isConnected {
                self.save(coordinate: CLLocationManager().location!.coordinate)
            }
        }
    }
    
    // Contains state of whether device is armed or not
    // In addition writing a 2 to this characteristic causes the device to
    // accept a new password
    private var isArmedCharacteristic : CBCharacteristic?
    
    private var batteryLifeCharacteristic : CBCharacteristic? {
        didSet {
            saveBatteryLife()
        }
    }
    
    init() {
        bleConnectionManger.checkConnection()
    }
    
    // Sets the values of our characteristics from a list of services
    func configureCharacteristics(forService service: CBService) {
        for characteristic in service.characteristics! {
            if characteristic.uuid == armCharCBUUID {
                isArmedCharacteristic = characteristic
            } else if characteristic.uuid == batteryLifeCharCBUUID {
                batteryLifeCharacteristic = characteristic
            }
        }
    }
    
    // Toggles isArmed in user preferences, the app's state, as well as the device
    func toggleAlarm() {
        UserDefaults.standard.set(!isArmed, forKey: "isArmed")
        isArmed = !isArmed
        
        if isArmedCharacteristic != nil {
            write(isArmed ? 1 : 0, toCharacteristic: self.isArmedCharacteristic!)
        } else {
            print("isArmedCharacteristic nil")
        }
    }
    
    func updatePassword() {
        if isArmedCharacteristic != nil {
            write(2, toCharacteristic: isArmedCharacteristic!)
        } else {
            print("isArmedCharacteristic nil")
        }
    }
    
    private func write(_ val: Int, toCharacteristic characteristic: CBCharacteristic) {
        if characteristic.properties.contains(.write) && peripheral != nil {
            let data = Data([UInt8(val)])
            peripheral?.writeValue(data, for: characteristic, type: .withResponse)
        }
    }
    
    // Saves coordinate in user preferences and updates the device state to
    // show most recent location
    private func save(coordinate: CLLocationCoordinate2D) {
        UserDefaults.standard.set(coordinate.latitude, forKey: "latitude")
        UserDefaults.standard.set(coordinate.longitude, forKey: "longitude")
        
        lastKnownLocation = CLLocationCoordinate2D(latitude: UserDefaults.standard.double(forKey: "latitude"),
                                                   longitude: UserDefaults.standard.double(forKey: "longitude"))
    }
    
    // Records current battery life in user preferences
    private func saveBatteryLife() {
        if let batteryLifeData = batteryLifeCharacteristic?.value {
            UserDefaults.standard.set(Int.from(data: batteryLifeData), forKey: "batteryLife")
        }
    }
}
