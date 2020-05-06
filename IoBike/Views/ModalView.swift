//
//  StateView.swift
//  IoBike
//
//  Created by James Lemkin on 5/4/20.
//  Copyright © 2020 James Lemkin. All rights reserved.
//

import SwiftUI

struct ModalView: View {
    @ObservedObject var bluetoothController: BluetoothController
    @State var isViewingState = true
    var shape = RoundedRectangle(cornerRadius: 30)
    
    func changeView() {
        isViewingState.toggle()
    }
    
    var body: some View {
        VStack {
            if isViewingState {
                StateView(bluetoothController: bluetoothController, changeView: changeView)
            } else {
                SettingsView(changeView: changeView)
            }
        }
        .frame(width: 325.0, height: 275.0)
        .overlay(
            shape.stroke(bluetoothController.isConnected ? Color.blue : Color.black, lineWidth: 2)
        )
        .background(
            shape.fill(Color(UIColor.systemBackground))
                .shadow(color: bluetoothController.isConnected ? Color.blue : Color.black, radius: 5)
        )
        .clipShape(shape)
    }
}

struct ModalView_Previews: PreviewProvider {
    static var previews: some View {
        ModalView(bluetoothController: BluetoothController())
    }
}
