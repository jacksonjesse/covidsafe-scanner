//
//  BluetoothDevice.swift
//  COVIDSafe Scanner
//
//  Created by Jesse Jackson on 27/4/20.
//  Copyright © 2020 Jesse Jackson. All rights reserved.
//

import Foundation
import CoreBluetooth

class BluetoothDevice: ObservableObject, Identifiable {
    var id = UUID().uuidString
    
    var peripheral: CBPeripheral?
    @Published var deviceId: String = "Unknown"
    @Published var name: String = "Unknown"
    @Published var model: String = ""
    @Published var state: State = .disconnected {
        willSet {
            if newValue == .connected || newValue == .dataAvailable {
                lastConnectionTime = Date()
            }
        }
    }
    @Published var lastConnectionTime: Date?
    
    var connectTimer: Timer? = nil
    
    init(peripheral: CBPeripheral?, name: String, model: String) {
        self.peripheral = peripheral
        self.name = name
        self.model = model
        self.state = .connected
        self.lastConnectionTime = Date()
    }
    
    func disconnect() {
        state = .disconnected
        stopMonitoring()
    }
    
    func stopMonitoring() {
        if connectTimer != nil {
            connectTimer!.invalidate()
            connectTimer = nil
        }
    }
    
    enum State {
        case disconnected
        case connected
        case dataAvailable
    }
}
