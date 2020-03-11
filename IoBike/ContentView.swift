//
//  ContentView.swift
//  IoBike
//
//  Created by James Lemkin on 3/9/20.
//  Copyright © 2020 James Lemkin. All rights reserved.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @ObservedObject var bluetoothController: BluetoothController
    
    var body: some View {
        VStack {
            MapView(bluetoothController: bluetoothController)
                .frame(height: 300.0)
                .edgesIgnoringSafeArea(.top)
            
            Text(bluetoothController.isConnected ? "Bike Connected" : "Bike Disconnected")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .padding()
            
            Text(bluetoothController.isArmed ? "Alarm Active" : "Alarm Inactive")
                .font(.title)
            
            Spacer()
            
            ToggleAlarmButton(bluetoothController: bluetoothController)
            
            Spacer()
        }
            
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(bluetoothController: BluetoothController())
    }
}
