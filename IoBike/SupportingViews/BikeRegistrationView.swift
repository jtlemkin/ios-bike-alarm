//
//  BikeRegistrationView.swift
//  IoBike
//
//  Created by James Lemkin on 5/12/20.
//  Copyright © 2020 James Lemkin. All rights reserved.
//

import SwiftUI

struct BikeRegistrationView: View {
    @State var newBikeID : String?
    
    func setBikeID(withID id: String) {
        newBikeID = id
    }
    
    var body: some View {
        VStack {
            if newBikeID == nil {
                QRScanView(onScan: setBikeID)
            } else {
                QRScanSuccessfulView(newBikeID: newBikeID!)
            }
        }
    }
}

struct BikeRegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        BikeRegistrationView()
    }
}
