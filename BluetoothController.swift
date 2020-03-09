//
//  BluetoothController.swift
//  IoBike
//
//  Created by James Lemkin on 3/9/20.
//  Copyright © 2020 James Lemkin. All rights reserved.
//

import Foundation
import CoreBluetooth

class BluetoothController: NSObject, ObservableObject {
    @Published var isConnected = false
    @Published var isArmed = false
    
    var centralManager : CBCentralManager!
    var alarmPeripheral : CBPeripheral!
    var isArmedCharacteristic : CBCharacteristic?
    
    let alarmCBUUID = CBUUID(string: "19b10000-e8f2-537e-4f6c-d104768a1214")
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
}

extension BluetoothController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
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
