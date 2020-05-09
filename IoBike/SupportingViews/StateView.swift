//
//  StateView.swift
//  IoBike
//
//  Created by James Lemkin on 5/6/20.
//  Copyright © 2020 James Lemkin. All rights reserved.
//

import SwiftUI

struct StateView: View {
    var device : Device
    var changeView : () -> Void
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("Device life: \(Int(UserDefaults.standard.double(forKey: "batteryLife")))%")
                    
                    Spacer()
                    
                    Button(action: changeView) {
                        Image(systemName: "gear").foregroundColor(Color(UIColor.label))
                    }
                }
                .padding(.all)
                
                Spacer()
            }
            
            if device.isConnected {
                ToggleAlarmButton(device: device)
            } else {
                Text(device.isArmed ? "Alarm Active" : "Alarm Inactive")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .padding()
            }
        }
    }
}

struct StateView_Previews: PreviewProvider {
    static var previews: some View {
        StateView(device: Device(), changeView: {})
    }
}
