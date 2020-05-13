//
//  ContentView.swift
//  IoBike
//
//  Created by James Lemkin on 3/9/20.
//  Copyright © 2020 James Lemkin. All rights reserved.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @EnvironmentObject var device : Device
    @State var userHasCompletedRegistration = false
    @State var userHasSeenOnBoarding = false
    
    func proceedToRegistration() {
        userHasSeenOnBoarding = true
    }
    
    func proceedToMainView() {
        userHasCompletedRegistration = true
    }
    
    var body: some View {
        VStack {
            if device.needsRegistration && !userHasCompletedRegistration {
                if userHasSeenOnBoarding {
                    BikeRegistrationView(firstTimeRegistering: true, onComplete: proceedToMainView)
                } else {
                    OnBoardingView(transition: proceedToRegistration)
                }
            } else {
                MainView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
