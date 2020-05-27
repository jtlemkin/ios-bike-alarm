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
        VStack() {
            Text("Report theft")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
                .padding([.all])
            
            VStack(alignment: .leading) {
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
                
                Spacer()
                
                Text(reported ? "Report complete" : "")
                    .padding([.horizontal])
                
                Button(action: {
                    if let name = self.deviceNameToReport {
                        self.reported = true
                        
                        var ref: DatabaseReference!
                        ref = Database.database().reference()
                        let uuid = UserDefaultsBackedDeviceStorage.getUUIDForDevice(withName: name)
                        
                        ref.child("Stolen Bike UUIDs").setValue([uuid: self.deviceDescription])
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
}

struct ReportingView_Previews: PreviewProvider {
    static var previews: some View {
        ReportingView()
    }
}
