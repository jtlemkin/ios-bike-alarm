//
//  SettingsView.swift
//  IoBike
//
//  Created by James Lemkin on 5/3/20.
//  Copyright © 2020 James Lemkin. All rights reserved.
//

import SwiftUI
import FirebaseDatabase

struct SettingsView: View {
    @State private var isScanningQR = false
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
                SettingsRow(imageName: "arrow.right.circle.fill", text: "Swap bike", action: {})
                SettingsRow(imageName: "plus.circle.fill", text: "Register New Device", action: startScan)
                SettingsRow(imageName: "exclamationmark.octagon.fill", text: "Report Stolen Bike", action: {
                    var ref: DatabaseReference!
                    ref = Database.database().reference()
                    
                    ref.child("UID").observeSingleEvent(of: .value, with: { (snapshot) in
                        // Get user value
                        let value = snapshot.value as? NSDictionary
                        print(value as Any)
                        // ...
                    }) { (error) in
                        print(error.localizedDescription)
                    }
                })
            }.sheet(isPresented: $isScanningQR) {
                BikeRegistrationView(firstTimeRegistering: false, onComplete: self.device.register)
            }
        }
    }
    
    struct SettingsView_Previews: PreviewProvider {
        static var previews: some View {
            SettingsView(changeView: {})
        }
    }
    
}

