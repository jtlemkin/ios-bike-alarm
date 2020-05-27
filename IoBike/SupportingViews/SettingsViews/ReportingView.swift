//
//  ReportingView.swift
//  IoBike
//
//  Created by James Lemkin on 5/26/20.
//  Copyright © 2020 James Lemkin. All rights reserved.
//

import SwiftUI
import FirebaseDatabase

struct ReportingView: View {
    let deviceNames = UserDefaultsBackedDeviceStorage.getAllDeviceNames()
    @EnvironmentObject var device: Device
    @State var deviceNameToReport : String?
    @State private var deviceDescription = ""
    @State var reported = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Report Theft")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
                .padding([.all])
                .padding([.bottom], 64)

            Text("Choose stolen bike")
                .fontWeight(.semibold)
                .padding([.all])
            
            ForEach(deviceNames, id: \.self) { name in
                Button(action: {
                    self.deviceNameToReport = name
                }) {
                    Text(name)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .padding([.all])
                        .background(Color.gray)
                        .border(self.deviceNameToReport == name ? Color(UIColor.label) : Color(UIColor.systemBackground), width: 2)
                        .padding(.horizontal)
                }
            }
            
            Text("Description of bike")
                .fontWeight(.semibold)
                .padding([.all])
            
            TextField("Optional", text: $deviceDescription)
                .padding([.all])
                .border(Color(UIColor.label))
                .padding([.horizontal])
            
            Text(reported ? "Report complete" : "")
                .padding([.horizontal])
            
            Spacer()
            
            Button(action: {
                if let name = self.deviceNameToReport {
                    var ref: DatabaseReference!
                    ref = Database.database().reference()
                    
                    if let uuid = UserDefaultsBackedDeviceStorage.getUUIDForDevice(withName: name) {
                        ref.child("Stolen Bike UUIDs").child(uuid).setValue(self.deviceDescription)
                        self.reported = true
                    }
                }
            }) {
                Text("Report")
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .padding([.all])
                    .background(Color.red)
                    .border(Color(UIColor.label))
                    .padding()
                }
        }
    }
}

struct ReportingView_Previews: PreviewProvider {
    static var previews: some View {
        ReportingView()
    }
}
