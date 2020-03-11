//
//  AlarmLockButton.swift
//  IoBike
//
//  Created by James Lemkin on 3/9/20.
//  Copyright © 2020 James Lemkin. All rights reserved.
//

import SwiftUI

struct ToggleAlarmButton: View {
    @ObservedObject var bluetoothController: BluetoothController
    
    var body: some View {
        Button(action: {
            self.bluetoothController.toggleAlarm()
        }) {
            Image(systemName: bluetoothController.isArmed ? "lock.fill" : "lock.open.fill")
                .font(.title)
            Text(bluetoothController.isArmed ? "Activate Alarm" : "Deactivate Alarm")
                .fontWeight(.semibold)
                .font(.title)
        }
        .padding()
        .foregroundColor(.white)
        .background(bluetoothController.isArmed ? Color.red : Color.gray)
        .cornerRadius(40)
    }
}

struct AlarmLockButton_Previews: PreviewProvider {
    static var previews: some View {
        ToggleAlarmButton(bluetoothController: BluetoothController())
    }
}
