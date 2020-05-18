//
//  QRScanView.swift
//  IoBike
//
//  Created by James Lemkin on 5/12/20.
//  Copyright © 2020 James Lemkin. All rights reserved.
//

import SwiftUI

struct QRScanView: View {
    var onScan : (String) -> Void
    var onUnableToAccessCamera : () -> Void
    
    var body: some View {
        ZStack {
            QRCaptureView(onScan: onScan, onUnableToAccessCamera: onUnableToAccessCamera)
            
            VStack {
                Text("Scan Bike Code")
                    .font(.title)
                    .foregroundColor(Color.white)
                    .padding(.vertical)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(/*@START_MENU_TOKEN@*/Color.blue/*@END_MENU_TOKEN@*/)
                
                Spacer()
            }
        }
    }
}

struct QRScanView_Previews: PreviewProvider {
    static var previews: some View {
        QRScanView(onScan: {_ in }, onUnableToAccessCamera: {})
    }
}
