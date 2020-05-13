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
    var onComplete: () -> Void
    
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
                ZStack {
                    QRScanSuccessfulView(newBikeID: newBikeID!)
                    
                    if firstTimeRegistering {
                        // The button is in a VStack and the padding is applied to the stack
                        // because otherwise the button would move, but its clickable area
                        // would not
                        VStack {
                            Button(action: onComplete) {
                                Text("Continue")
                                    .foregroundColor(.white)
                                    .font(.headline)
                                    .padding()
                                    .border(Color.white, width: 5)
                            }
                        }
                        .offset(y: 200)
                    }
                }
            }
        }
    }
}

struct BikeRegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        BikeRegistrationView(firstTimeRegistering: true, onComplete: {})
    }
}
