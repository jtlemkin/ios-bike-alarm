//
//  QRScanSuccessfulView.swift
//  IoBike
//
//  Created by James Lemkin on 5/12/20.
//  Copyright © 2020 James Lemkin. All rights reserved.
//

import SwiftUI

struct QRScanSuccessfulView: View {
    var newBikeID : String
    
    var body: some View {
        ZStack {
            Color.green
            
            VStack {
                
                Spacer()
                
                VStack {
                    Image(systemName: "checkmark.circle")
                        .resizable()
                        .frame(width: 200, height: 200)
                        .foregroundColor(.white)
                    
                    Text("Success!")
                        .font(.title)
                        .foregroundColor(Color.white)
                }

                Spacer()
                
                Text(newBikeID)
                
                Spacer()
            }
        }.edgesIgnoringSafeArea([.top, .bottom])
    }
}

struct QRScanSuccessfulView_Previews: PreviewProvider {
    static var previews: some View {
        QRScanSuccessfulView(newBikeID: "1234")
    }
}
