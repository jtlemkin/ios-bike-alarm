//
//  ContentView.swift
//  IoBike
//
//  Created by James Lemkin on 3/9/20.
//  Copyright © 2020 James Lemkin. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var bluetoothController: BluetoothController
    
    var body: some View {
        Text(bluetoothController.isConnected ? "Connected" : "Disconnected")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(bluetoothController: BluetoothController())
    }
}
