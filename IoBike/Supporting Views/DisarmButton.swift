//
//  DisarmView.swift
//  IoBike
//
//  Created by James Lemkin on 3/9/20.
//  Copyright © 2020 James Lemkin. All rights reserved.
//

import SwiftUI

struct DisarmButton: View {
    @ObservedObject var bluetoothController: BluetoothController
    
    var body: some View {
        Button(action: {
            self.bluetoothController.toggleAlarm()
        }) {
            Image(systemName: "lock.open.fill")
                .font(.title)
            Text("Deactivate Alarm")
                .fontWeight(.semibold)
                .font(.title)
        }
        .padding()
        .foregroundColor(.white)
        .background(Color.gray)
        .cornerRadius(40)
    }
}

struct DisarmView_Previews: PreviewProvider {
    static var previews: some View {
        DisarmButton(bluetoothController: BluetoothController())
    }
}
