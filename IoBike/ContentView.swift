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
            MapView(coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0))
                .frame(height: 300)
                .edgesIgnoringSafeArea(.top)
            
            Text(bluetoothController.isConnected ? "Connected to Bike" : "Disconnected from Bike")
                .font(.title)
                .fontWeight(.heavy)
                .padding()
            
            Spacer()
            
            Text(bluetoothController.isArmed ? "Alarm Active" : "Alarm Inactive")
                .font(.title)
                .padding()
            
            AlarmToggle(bluetoothController: bluetoothController)
            
            Spacer()
        }
            
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(bluetoothController: BluetoothController())
    }
}
