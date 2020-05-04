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
        VStack {
            HStack {
                Text("Device life: \(Int(defaults.double(forKey: "batteryLife")))%")
                
                Spacer()
                
                NavigationLink(destination: SettingsView()) {
                    Image(systemName: "gear")
                }
            }
            .padding(.all)
            
            Spacer()
            
            if bluetoothController.isConnected {
                ToggleAlarmButton(bluetoothController: bluetoothController)
            } else {
                Text(bluetoothController.isArmed ? "Alarm Active" : "Alarm Inactive")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .padding()
            }
            
            Spacer()
        }
        .frame(width: 300.0, height: 250.0)
        .overlay(
            RoundedRectangle(cornerRadius: 40)
                .stroke(Color.black, lineWidth: 3)
        )
        .background(RoundedRectangle(cornerRadius: 40).fill(Color.white))
        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
    }
}

struct StateView_Previews: PreviewProvider {
    static var previews: some View {
        StateView(bluetoothController: BluetoothController())
    }
}
