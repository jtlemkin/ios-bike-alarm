//
//  ContentView.swift
//  IoBike
//
//  Created by James Lemkin on 3/9/20.
//  Copyright © 2020 James Lemkin. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var bluetoothController: BluetoothController
    
    var body: some View {
        VStack {
            Text(bluetoothController.isConnected ? "Connected to Bike" : "Disconnected from Bike")
                .font(.title)
                .fontWeight(.heavy)
                .padding()
            Text(bluetoothController.isArmed ? "Alarm Active" : "Alarm Inactive")
                .font(.title)
                .padding()
            AlarmToggle(bluetoothController: bluetoothController)
        }
            
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(bluetoothController: BluetoothController())
    }
}
