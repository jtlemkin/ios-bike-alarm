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
    let defaults = UserDefaults.standard
    
    var body: some View {
        NavigationView {
            VStack {
                    VStack {
                        MapView(bluetoothController: bluetoothController)
                            .frame(height: CGFloat(300.0))
                        
                        HStack {
                            Text("Device life: \(Int(defaults.double(forKey: "batteryLife")))%")
                            
                            Spacer()
                            
                            NavigationLink(destination: SettingsView()) {
                                Image(systemName: "gear")
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                    
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
                .edgesIgnoringSafeArea(.top)
                    
            }
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
