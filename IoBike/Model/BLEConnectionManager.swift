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

class BLEConnectionManager: NSObject, ObservableObject {
    private lazy var centralManager = CBCentralManager(delegate: self, queue: nil)
    private unowned let targetDevice: Device
    
    init(device: Device) {
        self.targetDevice = device
        super.init()
    }
    
    func checkConnection() {
        print(centralManager.isScanning)
    }
    
}

extension BLEConnectionManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            print("Scanning for bluetooth devices")
            
            centralManager.scanForPeripherals(withServices: [self.targetDevice.serviceCBUUID])
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        centralManager.stopScan()
        centralManager.connect(peripheral)
        peripheral.delegate = self
        self.targetDevice.peripheral = peripheral
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected with target device")
        
        peripheral.discoverServices([self.targetDevice.serviceCBUUID])
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        self.targetDevice.peripheral = nil
        
        centralManager.scanForPeripherals(withServices: [self.targetDevice.serviceCBUUID])
    }
}

extension BLEConnectionManager: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                if service.uuid == self.targetDevice.serviceCBUUID {
                    peripheral.discoverCharacteristics(nil, for: service)
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        self.targetDevice.configureCharacteristics(forService: service)
    }
}
