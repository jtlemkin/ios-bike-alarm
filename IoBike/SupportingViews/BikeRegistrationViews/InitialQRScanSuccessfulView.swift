//
//  InitialQRScanSuccessfulView.swift
//  IoBike
//
//  Created by James Lemkin on 5/13/20.
//  Copyright © 2020 James Lemkin. All rights reserved.
//

import SwiftUI

struct InitialQRScanSuccessfulView: View {
    @State var bikeName: String = "New Bike"
    var newBikeID : String
    var onComplete : (String) -> Void
    
    var body: some View {
        ZStack {
            Color.green
                .edgesIgnoringSafeArea([.top, .bottom])
            
            VStack {
                Spacer(minLength: 50)
                
                SuccessView()
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
                
                Spacer(minLength: 100)
                
                Button(action: { self.onComplete(self.bikeName) } ) {
                    Text("Continue")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                        .border(Color.white, width: 5)
                }
                
                Spacer(minLength: 200)
            }
        }
    }
}

struct InitialQRScanSuccessfulView_Previews: PreviewProvider {
    static var previews: some View {
        InitialQRScanSuccessfulView(newBikeID: "1234", onComplete: {_ in })
    }
}
