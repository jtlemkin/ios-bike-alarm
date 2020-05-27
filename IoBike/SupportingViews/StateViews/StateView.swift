//
//  StateView.swift
//  IoBike
//
//  Created by James Lemkin on 5/6/20.
//  Copyright © 2020 James Lemkin. All rights reserved.
//

import SwiftUI

struct StateView: View {
    @EnvironmentObject var device : Device
    var changeView : () -> Void
    let batteryLife = UserDefaults.standard.integer(forKey: "batteryLife")
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("Device life: \(batteryLife == 0 ? 100 : batteryLife)%")
                    
                    Spacer()
                    
                    Button(action: changeView) {
                        Image(systemName: "gear").foregroundColor(Color(UIColor.label))
                    }
                }
                .padding(.all)
                
                Spacer()
            }
            
            VStack {
                Text(device.name)
                    .font(.headline)
                
                if device.isConnected {
                    ToggleAlarmButton()
                } else {
                    Text(device.isArmed ? "Alarm Active" : "Alarm Inactive")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .padding()
                }
            }
        }
    }
}

struct StateView_Previews: PreviewProvider {
    static var previews: some View {
        StateView(changeView: {})
    }
}
