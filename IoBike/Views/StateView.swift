//
//  StateView.swift
//  IoBike
//
//  Created by James Lemkin on 5/6/20.
//  Copyright © 2020 James Lemkin. All rights reserved.
//

import SwiftUI

struct StateView: View {
    @ObservedObject var bluetoothController: BluetoothController
    var changeView : () -> Void
    let defaults = UserDefaults.standard
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("Device life: \(Int(defaults.double(forKey: "batteryLife")))%")
                    
                    Spacer()
                    
                    Button(action: changeView) {
                        Image(systemName: "gear").foregroundColor(Color(UIColor.label))
                    }
                }
                .padding(.all)
                
                Spacer()
            }
            
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
        StateView(bluetoothController: BluetoothController(), changeView: {})
    }
}
