//
//  StateView.swift
//  IoBike
//
//  Created by James Lemkin on 5/4/20.
//  Copyright © 2020 James Lemkin. All rights reserved.
//

import SwiftUI

struct StateView: View {
    @ObservedObject var bluetoothController: BluetoothController
    let defaults = UserDefaults.standard
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("Device life: \(Int(defaults.double(forKey: "batteryLife")))%")
                    
                    Spacer()
                    
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gear").foregroundColor(Color(UIColor.label))
                    }
                }
                .padding(.all)
                
                Spacer()
            }
            .frame(width: 325.0, height: 275.0)
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(bluetoothController.isConnected ? Color.blue : Color.black, lineWidth: 2)
            )
            .background(
                RoundedRectangle(cornerRadius: 30).fill(Color(UIColor.systemBackground))
                    .shadow(color: bluetoothController.isConnected ? Color.blue : Color.black, radius: 5)
            )
            
            if bluetoothController.isConnected {
                ToggleAlarmButton(bluetoothController: bluetoothController)
            } else {
                Text(bluetoothController.isArmed ? "Alarm Active" : "Alarm Inactive")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .padding()
            }
        }
    }
}

struct StateView_Previews: PreviewProvider {
    static var previews: some View {
        StateView(bluetoothController: BluetoothController())
    }
}
