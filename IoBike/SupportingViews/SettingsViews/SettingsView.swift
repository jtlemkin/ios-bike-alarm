//
//  SettingsView.swift
//  IoBike
//
//  Created by James Lemkin on 5/3/20.
//  Copyright © 2020 James Lemkin. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @State private var isScanningQR = false
    @EnvironmentObject var device : Device
    var changeView : () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Button(action: changeView) {
                Image(systemName: "chevron.left").foregroundColor(Color(UIColor.label)).padding([.leading, .top])
            }
            
            Text("Settings")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
                .padding(.horizontal)
            
            List {
                SettingsRow(imageName: "arrow.up.arrow.down.circle.fill", text: "Set password", action: device.updatePassword)
                SettingsRow(imageName: "plus.circle.fill", text: "Register New Device", action: { self.isScanningQR.toggle() })
                SettingsRow(imageName: "exclamationmark.octagon.fill", text: "Report Stolen Bike", action: {})
            }
        }.sheet(isPresented: $isScanningQR) {
            // Currently onComplete is only used the first time a device is registered in order to transition to the main view
            BikeRegistrationView(firstTimeRegistering: false, onComplete: {})
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(changeView: {})
    }
}
