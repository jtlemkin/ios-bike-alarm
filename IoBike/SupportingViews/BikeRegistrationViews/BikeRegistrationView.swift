//
//  BikeRegistrationView.swift
//  IoBike
//
//  Created by James Lemkin on 5/12/20.
//  Copyright © 2020 James Lemkin. All rights reserved.
//

import SwiftUI

struct BikeRegistrationView: View {
    @State var newBikeID : String? = nil
    var firstTimeRegistering : Bool
    var onComplete: (String) -> Void
    
    func setBikeID(withID id: String) {
        newBikeID = id
    }
    
    var body: some View {
        VStack {
            if newBikeID == nil {
                ZStack {
                    if firstTimeRegistering {
                        Color.blue
                            .edgesIgnoringSafeArea(.top)
                    }
                    
                    QRScanView(onScan: setBikeID)
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
