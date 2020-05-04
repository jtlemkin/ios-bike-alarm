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
    @ObservedObject var bluetoothController = BluetoothController()
    
    var body: some View {
        VStack {
            VStack {
                MapView(bluetoothController: bluetoothController)
                    .frame(height: CGFloat(300.0))
                
                HStack {
                    Text("Device life: \(bluetoothController.batteryLife == nil ? "undefined" : String(bluetoothController.batteryLife!) + "%")")
                    
                    Spacer()
                }
                .padding(.horizontal)
            }.edgesIgnoringSafeArea(.top)
            
            
            Text(bluetoothController.isConnected ? "Bike Connected" : "Bike Disconnected")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .padding()
            
            Spacer()
            
            if bluetoothController.isConnected {
                ToggleAlarmButton(bluetoothController: bluetoothController)
            } else {
                Text(bluetoothController.isArmed ? "Alarm Active" : "Alarm Inactive")
                    .font(.title)
            }
            
            Spacer()
        }
            
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(bluetoothController: BluetoothController())
    }
}
