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
    @Published var isArmed = false
    @Published var lastKnownLocation = CLLocationManager().location?.coordinate
        ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)
    @Published var name = ""
    @Published var batteryLife = 0.0
    @Published var hasError = false
    
    //The BLE Connection Manager is responsible for setting the peripheral variable of the device
    private lazy var bleConnectionManger = BLEConnectionManager(device: self)
    private lazy var storage = UserDefaultsBackedDeviceStorage(device: self)
    
    static let shared = Device()
    
    var id: String {
        return storage.id
    }
    
    var cbuuid: CBUUID {
        return CBUUID(string: "19b10000-\(storage.id)-537e-4f6c-d104768a1214")
    }
    
    var errorMessage: String? {
        didSet {
            hasError = errorMessage != nil
        }
    }
    
    var needsRegistration: Bool {
        return storage.name == nil
    }
    
    var peripheral : CBPeripheral? {
        didSet {
            isConnected = peripheral != nil

            if isConnected {
                storage.update(isArmed: false)
            } else {
                storage.update(isArmed: true)
                storage.saveCurrentLocation()
                isArmedCharacteristic = nil
                batteryLifeCharacteristic = nil
            }
        }
    }
    
    // Contains state of whether device is armed or not
    // In addition writing a 2 to this characteristic causes the device to
    // accept a new password
    private var isArmedCharacteristic : CBCharacteristic?
    
    private var batteryLifeCharacteristic : CBCharacteristic? {
        didSet {
            if let characteristic = batteryLifeCharacteristic {
                storage.update(batteryLife: read(fromCharacteristic: characteristic))
            }
        }
    }
    
    init() {
        syncStateWithStorage()
        bleConnectionManger.checkConnection()
    }
    
    func syncStateWithStorage() {
        isArmed = storage.isArmed
        
        if !(storage.lastKnownLocation.latitude == 0 && storage.lastKnownLocation.longitude == 0) {
            lastKnownLocation = storage.lastKnownLocation
        }
        
        name = storage.name ?? "unnamed bike"
        batteryLife = storage.batteryLife
    }
    
    //Returns whether registration was successful or not
    func register(withName name: String, withID id: String) -> Bool {
        if id.count == 4 && isHexadecimal(number: id) {
            storage.register(withName: name, withID: id)
            return true
        } else {
            return false
        }
    }
    
    func swap() {
        storage.swap()
    }
    
    // Sets the values of our characteristics from a list of services
    func configureCharacteristics(forService service: CBService) {
        isArmedCharacteristic = service.characteristics![0]
        batteryLifeCharacteristic = service.characteristics![1]
    }
    
    // Toggles isArmed in user preferences, the app's state, as well as the device
    func toggleAlarm() {
        if isArmedCharacteristic == nil {
            errorMessage = "Device not connected"
        } else {
            storage.update(isArmed: !isArmed)
            write(isArmed ? 1 : 0, toCharacteristic: self.isArmedCharacteristic!)
        }
    }
    
    func updatePassword() {
        if isArmedCharacteristic == nil {
            errorMessage = "Device not connected"
        } else {
            write(2, toCharacteristic: isArmedCharacteristic!)
        }
    }
    
    private func write(_ val: Int, toCharacteristic characteristic: CBCharacteristic) {
        if peripheral == nil {
            errorMessage = "Device not connected"
        } else if characteristic.properties.contains(.write) {
            let data = Data([UInt8(val)])
            peripheral!.writeValue(data, for: characteristic, type: .withResponse)
        }
    }
    
    private func read(fromCharacteristic characteristic: CBCharacteristic) -> Int {
        if let peripheral = peripheral {
            peripheral.readValue(for: characteristic)
            return Int.from(data: characteristic.value!)
        } else {
            errorMessage = "Device not connected"
            return -1
        }
    }
    
    func dismissError() {
        errorMessage = nil
    }
}
