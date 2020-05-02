//
//  BluetoothDeviceList.swift
//  COVIDSafe Scanner
//
//  Created by Jesse Jackson on 27/4/20.
//  Copyright © 2020 Jesse Jackson. All rights reserved.
//

import Foundation
import CoreBluetooth

class BluetoothDeviceList : ObservableObject {
    @Published var devices : [BluetoothDevice]
    
    init() {
        devices = []
    }
    
    init(devices: [BluetoothDevice]) {
        self.devices = devices
    }
}
