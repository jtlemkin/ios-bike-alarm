//
//  QRScanView.swift
//  IoBike
//
//  Created by James Lemkin on 5/11/20.
//  Copyright © 2020 James Lemkin. All rights reserved.
//

import SwiftUI

struct QRScanView: View {
    var body: some View {
        ZStack {
            QRScanner()
            
            VStack {
                Text("Scan")
                    .font(.title)
                    .foregroundColor(Color.white)
                    .padding(.vertical)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(/*@START_MENU_TOKEN@*/Color.blue/*@END_MENU_TOKEN@*/)
                
                Spacer()
                
                Text("No QR code is detected")
            }
            .frame(minWidth: 0, maxWidth: .infinity)
        }
    }
}

struct QRScanView_Previews: PreviewProvider {
    static var previews: some View {
        QRScanView()
    }
}
