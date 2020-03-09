//
//  AlarmToggle.swift
//  IoBike
//
//  Created by James Lemkin on 3/9/20.
//  Copyright © 2020 James Lemkin. All rights reserved.
//

import SwiftUI
import MapKit

struct AlarmToggle: View {
    @ObservedObject var bluetoothController : BluetoothController
    
    var body: some View {
        VStack {
            Toggle(isOn: $bluetoothController.isArmed) {
                Text(bluetoothController.isArmed ? "Deactivate Alarm" : "Activate Alarm")
                    .foregroundColor(Color.white)
            }
            .accentColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
        }
        .padding()
        .background(bluetoothController.isArmed ? Color.red : Color.blue)
    }
}

struct AlarmToggle_Previews: PreviewProvider {
    static var previews: some View {
        AlarmToggle(bluetoothController: BluetoothController())
    }
}
