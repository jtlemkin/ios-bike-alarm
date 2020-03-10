//
//  AlarmLockButton.swift
//  IoBike
//
//  Created by James Lemkin on 3/9/20.
//  Copyright © 2020 James Lemkin. All rights reserved.
//

import SwiftUI

struct ArmButton: View {
    @ObservedObject var bluetoothController: BluetoothController
    
    var body: some View {
        Button(action: {
            self.bluetoothController.toggleAlarm()
        }) {
            Image(systemName: "lock.fill")
                .font(.title)
            Text("Activate Alarm")
                .fontWeight(.semibold)
                .font(.title)
        }
        .padding()
        .foregroundColor(.white)
        .background(Color.red)
        .cornerRadius(40)
    }
}

struct AlarmLockButton_Previews: PreviewProvider {
    static var previews: some View {
        ArmButton(bluetoothController: BluetoothController())
    }
}
