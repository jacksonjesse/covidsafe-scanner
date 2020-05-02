//
//  BluetoothScanner.swift
//  COVIDSafe Scanner
//
//  Created by Jesse Jackson on 27/4/20.
//  Copyright © 2020 Jesse Jackson. All rights reserved.
//

import Foundation
import CoreBluetooth
import UIKit

class BluetoothScanner : NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    static let shared = BluetoothScanner()
    var covideSafeDeviceList = BluetoothDeviceList()
    var peripherals: [CBPeripheral] = []
    
    var manager : CBCentralManager!
    var scanning = true
    
    let feedbackGenerator = UINotificationFeedbackGenerator()
    
    let COVID_SAFE_SERVICE = "B82AB3FC-1595-4F6A-80F0-FE094CC218F9"
    let DEVICE_TYPE = "2A24"
    
    override init() {
        super.init()
        
        feedbackGenerator.prepare()
        
        manager = CBCentralManager(delegate: self, queue: nil)

        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true, block: {timer in
            for device in self.covideSafeDeviceList.devices {
                let fiveSecondsAgo = Date().addingTimeInterval(-5.0)
                if device.lastConnectionTime?.compare(fiveSecondsAgo) == ComparisonResult.orderedAscending {
                    device.state = .disconnected
                }
            }
        })
    }
    
    func startScan() {
        manager.scanForPeripherals(withServices: [CBUUID( string: "B82AB3FC-1595-4F6A-80F0-FE094CC218F9")], options: nil)
        scanning = true
    }
    
    func stopScan() {
        manager.stopScan()
        scanning = false
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        // Not implemented
    }
    
    func clearCOVIDSafeDevices() {
        let wasScanning = scanning
        
        if scanning {
            stopScan()
        }
        
        
        for device in self.covideSafeDeviceList.devices {
            device.stopMonitoring()
        }
            
        self.covideSafeDeviceList.devices.removeAll()
        self.peripherals.removeAll()
        
        delay(1) {
            if wasScanning {
                self.startScan()
            }
        }
        
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        peripheral.delegate = self
        
        if !self.peripherals.contains(peripheral) {
            self.peripherals.append(peripheral)
            
            print("*** Peripheral ***")
            print("   Peripheral: \(peripheral)")
            print("**********************\n")
            
            let bluetoothDevice = BluetoothDevice(peripheral: peripheral, name: peripheral.name ?? "Unknown", model: "")
            bluetoothDevice.connectTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true, block: {timer in
                self.manager.connect(peripheral)
            })
            
            covideSafeDeviceList.devices.append(bluetoothDevice)
            
            feedbackGenerator.notificationOccurred(.success)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices(nil)
        let device = getDevice(peripheral: peripheral)
        if device == nil {
            return
        }
        
        if device!.state != .dataAvailable {
            device!.state = .connected
        }
        
        device!.name = peripheral.name ?? "Unknown"
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        let device = getDevice(peripheral: peripheral)
        if device == nil {
            return
        }
        
        device!.state = .disconnected
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        let device = getDevice(peripheral: peripheral)
        if device == nil {
            return
        }
        
        device!.state = .disconnected
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service in peripheral.services! {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for characteristic in service.characteristics! {
            if characteristic.uuid.uuidString == DEVICE_TYPE {
                peripheral.readValue(for: characteristic)
            }
            
            if characteristic.uuid.uuidString == COVID_SAFE_SERVICE {
                let device = getDevice(peripheral: peripheral)
                
                if device == nil {
                    return
                }
                
                device!.state = .dataAvailable
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if characteristic.value != nil {
            let unwrappedValue = String(bytes: characteristic.value!, encoding: String.Encoding.utf8)
            
            if unwrappedValue != nil {
                if characteristic.uuid.uuidString == DEVICE_TYPE {
                    let device = getDevice(peripheral: peripheral)
                    
                    if device == nil {
                        return
                    }
                    
                    device!.model = unwrappedValue!
                }
            }
        }
    }
    
    func getDevice(peripheral: CBPeripheral) -> BluetoothDevice? {
        for device in covideSafeDeviceList.devices {
            if device.peripheral == peripheral {
                return device
            }
        }
        
        return nil
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
}
