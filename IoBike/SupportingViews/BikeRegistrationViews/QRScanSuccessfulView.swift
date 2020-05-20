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
    @State var success = false
    var newBikeID : String
    
    var body: some View {
        ZStack {
            Color.green
            
            VStack {
                Spacer()
                    .frame(height: 50)
                
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
                
                VStack(alignment: .leading) {
                    Text("Enter name for bike")
                        .font(.headline)
                        .foregroundColor(.white)
                    TextField("", text: $bikeName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding(.all)
                
                Spacer()
                
                // When the app has at least one registered device, the device variable "needsRegistration"
                // is set to false and the content view directs the user to main page
                Button(action: {
                    if !self.success {
                        var _ = Device.shared.register(withName: self.bikeName, withID: self.newBikeID)
                        self.success = true
                    }
                } ) {
                    Text("Register")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                        .border(Color.white, width: 5)
                }
                
                Text("Registration successful!")
                    .foregroundColor(success ? .white : .green)
                    .padding(.all)
                
                Spacer()
            }
        }
        .edgesIgnoringSafeArea([.top, .bottom])
    }
}

struct QRScanSuccessfulView_Previews: PreviewProvider {
    static var previews: some View {
        QRScanSuccessfulView(newBikeID: "1234")
    }
}
