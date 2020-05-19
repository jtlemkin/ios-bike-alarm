//
//  BikeRegistrationView.swift
//  IoBike
//
//  Created by James Lemkin on 5/12/20.
//  Copyright © 2020 James Lemkin. All rights reserved.
//

import SwiftUI

struct BikeRegistrationView: View {
    @EnvironmentObject var device : Device
    @State var newBikeID : String? = nil
    var firstTimeRegistering : Bool
    
    @State var ableToAccessCamera: Bool = true
    @State private var code: String = ""
    
    func setBikeID(withID id: String) {
        newBikeID = id
    }
    
    func updateCameraAccess() {
        ableToAccessCamera = false
    }
    
    func attemptRegistration() {
        if device.register(withName: "hello", withID: code) {
            newBikeID = code
        }
    }
    
    var body: some View {
        VStack {
            if newBikeID == nil {
                if ableToAccessCamera {
                    QRScanView(onScan: setBikeID, onUnableToAccessCamera: updateCameraAccess)
                } else {
                    // Manual registration view
                    VStack {
                        Text("Please enter 4 digit bike code")
                        TextField("", text: $code)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        Button(action: attemptRegistration) {
                            Text("Continue")
                        }
                    }
                }
            } else {
                if firstTimeRegistering {
                    InitialQRScanSuccessfulView(newBikeID: newBikeID!)
                } else {
                    QRScanSuccessfulView(newBikeID: newBikeID!)
                }
            }
        }
    }
}

struct BikeRegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        BikeRegistrationView(firstTimeRegistering: true)
    }
}
