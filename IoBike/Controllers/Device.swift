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
    
    private var isArmedCharacteristic : CBCharacteristic?
    private var batteryLifeCharacteristic : CBCharacteristic? {
        didSet {
            if let batteryLifeData = batteryLifeCharacteristic?.value {
                UserDefaults.standard.set(Int.from(data: batteryLifeData), forKey: "batteryLife")
            }
        }
    }
    
    init() {
        bleConnectionManger.checkConnection()
    }
    
    func configureCharacteristics(forService service: CBService) {
        for characteristic in service.characteristics! {
            if characteristic.uuid == armCharCBUUID {
                isArmedCharacteristic = characteristic
            } else if characteristic.uuid == batteryLifeCharCBUUID {
                batteryLifeCharacteristic = characteristic
            }
        }
    }
    
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
    
    private func save(coordinate: CLLocationCoordinate2D) {
        UserDefaults.standard.set(coordinate.latitude, forKey: "latitude")
        UserDefaults.standard.set(coordinate.longitude, forKey: "longitude")
        
        lastKnownLocation = CLLocationCoordinate2D(latitude: UserDefaults.standard.double(forKey: "latitude"),
                                                   longitude: UserDefaults.standard.double(forKey: "longitude"))
    }
}
