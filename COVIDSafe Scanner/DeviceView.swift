//
//  DeviceView.swift
//  COVIDSafe Scanner
//
//  Created by Jesse Jackson on 27/4/20.
//  Copyright © 2020 Jesse Jackson. All rights reserved.
//

import SwiftUI

struct DeviceView: View {
    @EnvironmentObject var device: BluetoothDevice
        
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(device.name)")
                    .padding(.bottom, 5.0)
                    
                Text("\(device.model)")
                    .font(.caption)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .trailing) {
                if device.state == .dataAvailable {
                    Text("Connected (Data Available)")
                        .font(.caption)
                        .fontWeight(.bold)
                } else if device.state == .connected {
                    Text("Connected (No Data)")
                        .font(.caption)
                        .fontWeight(.bold)
                } else {
                    Text("Disconnected")
                        .font(.caption)
                }
                
                if device.lastConnectionTime != nil {
                    Text("Last Seen\n\(Utilities.formatCalendar(date: device.lastConnectionTime!))")
                        .font(.caption)
                        .padding(.top, 5.0)
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .multilineTextAlignment(.trailing)
        }
    }
}

struct DeviceView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceView()
        .environmentObject(
                BluetoothDevice(peripheral: nil, name: "Name", model: "Model")
        )
    }
}
