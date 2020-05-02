//
//  ContentView.swift
//  COVIDSafe Scanner
//
//  Created by Jesse Jackson on 27/4/20.
//  Copyright © 2020 Jesse Jackson. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var deviceList: BluetoothDeviceList
    @State var scanning = false
        
    var body: some View {
        NavigationView() {
            List(deviceList.devices) { device in
                DeviceView()
                .environmentObject(device)
            }
            .navigationBarTitle(Text("COVIDSafe Devices"))
            .navigationBarItems(leading: Button(action: clearDevices, label: {
                Text("Clear History")
            }),
                                trailing: ScanButtonView(scanning: scanning)
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func clearDevices() {
        BluetoothScanner.shared.clearCOVIDSafeDevices()
    }
    
    func startOrStopScan() {
        if scanning {
            BluetoothScanner.shared.stopScan()
            scanning = false
        } else {
            BluetoothScanner.shared.startScan()
            scanning = true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        .environmentObject(BluetoothDeviceList(
            devices: [
                BluetoothDevice(peripheral: nil, name: "Name", model: "Model")
            ]
        ))
    }
}
