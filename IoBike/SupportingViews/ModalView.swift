//
//  StateView.swift
//  IoBike
//
//  Created by James Lemkin on 5/4/20.
//  Copyright © 2020 James Lemkin. All rights reserved.
//

import SwiftUI

struct ModalView: View {
    @State var isViewingState = true
    var shape = RoundedRectangle(cornerRadius: 30)
    let bluetoothBlue = Color(red: 0.157, green: 0.478, blue: 0.662)
    
    var device : Device
    
    func changeView() {
        isViewingState.toggle()
    }
    
    var body: some View {
        VStack {
            if isViewingState {
                StateView(device: device, changeView: changeView)
            } else {
                SettingsView(device: device, changeView: changeView)
            }
        }
        .frame(width: 325.0, height: 275.0)
        .clipShape(shape)
        .overlay(
            shape.stroke(device.isConnected ? bluetoothBlue : Color.black, lineWidth: 2)
        )
        .background(
            shape.fill(Color(UIColor.systemBackground))
                .shadow(color: device.isConnected ? bluetoothBlue : Color.black, radius: 5)
        )
    }
}

struct ModalView_Previews: PreviewProvider {
    static var previews: some View {
        ModalView(device: Device())
    }
}
