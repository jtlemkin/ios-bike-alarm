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
    @State private var isReporting = false
    @EnvironmentObject var device : Device
    var changeView : () -> Void
    
    func startScan() {
        isScanningQR = true
    }
    
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
                SettingsRow(imageName: "arrow.right.circle.fill", text: "Swap bike", action: device.swap)
                SettingsRow(imageName: "plus.circle.fill", text: "Register New Device", action: startScan)
                .sheet(isPresented: $isScanningQR) {
                    BikeRegistrationView()
                }
                SettingsRow(imageName: "exclamationmark.octagon.fill", text: "Report Stolen Bike", action: {
                    self.isReporting = true
                })
                .sheet(isPresented: $isReporting) {
                    ReportingView()
                }
            }
        }
    }
    
    struct SettingsView_Previews: PreviewProvider {
        static var previews: some View {
            SettingsView(changeView: {})
        }
    }
    
}

