//
//  QRScanSuccessfulView.swift
//  IoBike
//
//  Created by James Lemkin on 5/12/20.
//  Copyright © 2020 James Lemkin. All rights reserved.
//

import SwiftUI

struct QRScanSuccessfulView: View {
    @State var bikeName: String = "New Bike"
    var newBikeID : String
    
    var body: some View {
        ZStack {
            Color.green
            
            VStack {
                Spacer(minLength: 50)
                
                VStack {
                    Image(systemName: "checkmark.circle")
                        .resizable()
                        .frame(width: 200, height: 200)
                        .foregroundColor(.white)
                    
                    Text("Success!")
                        .font(.title)
                        .foregroundColor(.white)
                }
                .padding(.top, 32.0)
                .padding(.bottom)
                
                Spacer()
                
                VStack(alignment: .leading) {
                    Text("Enter name for bike")
                        .font(.headline)
                        .foregroundColor(.white)
                    TextField("", text: $bikeName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding(.all)
                
                Spacer(minLength: 300)
            }
        }.edgesIgnoringSafeArea([.top, .bottom])
    }
}

struct QRScanSuccessfulView_Previews: PreviewProvider {
    static var previews: some View {
        QRScanSuccessfulView(newBikeID: "1234")
    }
}
