//
//  ScanButtonView.swift
//  COVIDSafe Scanner
//
//  Created by Jesse Jackson on 28/4/20.
//  Copyright © 2020 Jesse Jackson. All rights reserved.
//

import SwiftUI

struct ScanButtonView: View {
    @State var scanning: Bool
        
    var body: some View {
        HStack {
            ActivityIndicator(isAnimating: $scanning)
            Button(action: startOrStopScan, label: {
                Text(scanning ? "Stop Scanning" : "Start Scanning")
            })
        }
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

struct ScanButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ScanButtonView(scanning: true)
    }
}
