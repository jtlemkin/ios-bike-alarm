//
//  OnBoardingView.swift
//  IoBike
//
//  Created by James Lemkin on 5/13/20.
//  Copyright © 2020 James Lemkin. All rights reserved.
//

import SwiftUI

struct OnBoardingView: View {
    var transition: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Welcome to BikeBuddy!")
                .font(.title)
                .padding(.all)
            
            Text("First, please take out your device's QR code")
            
            Spacer()
            
            Button(action: transition) {
                Text("Continue")
                    .foregroundColor(Color(UIColor.label))
                    .font(.headline)
                    .padding()
                    .border(Color(UIColor.label), width: 5)
            }
            
            Spacer()
        }
    }
}

struct OnBoardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingView(transition: {})
    }
}
