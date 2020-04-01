//
//  BluetoothController.swift
//  IoBike
//
//  Created by James Lemkin on 3/9/20.
//  Copyright © 2020 James Lemkin. All rights reserved.
//

import Foundation
import CoreBluetooth
import CoreLocation

class BluetoothController: NSObject, ObservableObject {
    @Published var isConnected = false
    
    @Published var isArmed = false
    
    var centralManager : CBCentralManager!
    var alarmPeripheral : CBPeripheral!
    var isArmedCharacteristic : CBCharacteristic?
    
    let locationManager = CLLocationManager()
    
    var lastSeenBikeLocation : CLLocationCoordinate2D {
        var latitude = defaults.double(forKey: "latitude")
        var longitude = defaults.double(forKey: "longitude")
        
        //DEBUG
        if latitude == 0.0 && longitude == 0.0 {
            latitude = 38.5401844
            longitude = -121.7491281
        }
        
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    let defaults = UserDefaults.standard
    
    let alarmCBUUID = CBUUID(string: "19b10000-e8f2-537e-4f6c-d104768a1214")
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func updateAlarmPeripheral() {
        if let characteristic = isArmedCharacteristic {
            if characteristic.properties.contains(.write) && alarmPeripheral != nil {
                let data = Data([UInt8(isArmed ? 1 : 0)])
                alarmPeripheral.writeValue(data, for: characteristic, type: .withResponse)
            }
        }
    }
    
    func save(coordinate: CLLocationCoordinate2D) {
        defaults.set(coordinate.latitude, forKey: "latitude")
        defaults.set(coordinate.longitude, forKey: "longitude")
    }
    
    func toggleAlarm() {
        defaults.set(!isArmed, forKey: "isArmed")
        isArmed = defaults.bool(forKey: "isArmed")
        
        updateAlarmPeripheral()
    }
}

extension BluetoothController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            print("Scanning for bluetooth devices")
            
            centralManager.scanForPeripherals(withServices: [alarmCBUUID])
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        alarmPeripheral = peripheral
        centralManager.stopScan()
        centralManager.connect(alarmPeripheral)
        alarmPeripheral.delegate = self
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected with alarm")
        
        self.isConnected = true
        alarmPeripheral.discoverServices([alarmCBUUID])
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        self.isConnected = false
        self.alarmPeripheral = nil
        
        self.save(coordinate: locationManager.location!.coordinate)
        
        centralManager.scanForPeripherals(withServices: [alarmCBUUID])
    }
}

extension BluetoothController: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                if service.uuid == alarmCBUUID {
                    peripheral.discoverCharacteristics(nil, for: service)
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                isArmedCharacteristic = characteristic
            }
        }
    }
}
