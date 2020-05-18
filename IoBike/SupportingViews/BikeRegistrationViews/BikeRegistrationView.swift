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
    var onComplete: (String) -> Void
    
    @State var ableToAccessCamera: Bool = true
    @State private var code: String = ""
    
    func setBikeID(withID id: String) {
        newBikeID = id
    }
    
    func updateCameraAccess() {
        ableToAccessCamera = false
    }
    
    var body: some View {
        VStack {
            if newBikeID == nil {
                if ableToAccessCamera {
                    ZStack {
                        if firstTimeRegistering {
                            Color.blue
                                .edgesIgnoringSafeArea(.top)
                            
                            Text("If you see this, go to settings and disable camera permission. Sorry for the inconvenience")
                        }
                        
                        QRScanView(onScan: setBikeID, onUnableToAccessCamera: updateCameraAccess )
                    }
                } else {
                    // Manual registration view
                    VStack {
                        Text("Please enter 4 digit bike code")
                        TextField("", text: $code)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        Button(action: { self.device.register(withName: self.code) }) {
                            Text("Continue")
                        }
                    }
                }
            } else {
                if firstTimeRegistering {
                    InitialQRScanSuccessfulView(newBikeID: newBikeID!, onComplete: onComplete)
                } else {
                    QRScanSuccessfulView(newBikeID: newBikeID!, onComplete: onComplete)
                }
            }
        }
    }
}

struct BikeRegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        BikeRegistrationView(firstTimeRegistering: true, onComplete: {_ in})
    }
}
