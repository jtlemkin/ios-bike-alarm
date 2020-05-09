//
//  AlarmLockButton.swift
//  IoBike
//
//  Created by James Lemkin on 3/9/20.
//  Copyright © 2020 James Lemkin. All rights reserved.
//

import SwiftUI

struct ToggleAlarmButton: View {
    var device: Device
    
    var body: some View {
        Button(action: {
            self.device.toggleAlarm()
        }) {
            Image(systemName: !device.isArmed ? "lock.fill" : "lock.open.fill")
                .font(.title)
            Text(!device.isArmed ? "Activate Alarm" : "Deactivate Alarm")
                .fontWeight(.semibold)
                .font(.title)
        }
        .padding()
        .foregroundColor(.white)
        .background(!device.isArmed ? Color.red : Color.gray)
        .cornerRadius(40)
    }
}

struct AlarmLockButton_Previews: PreviewProvider {
    static var previews: some View {
        ToggleAlarmButton(device: Device())
    }
}
