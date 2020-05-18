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
    
    var body: some View {
        VStack {
            #if targetEnvironment(simulator)
                MainView()
            #else
                if device.needsRegistration && !userHasCompletedRegistration {
                    if userHasSeenOnBoarding {
                        BikeRegistrationView(firstTimeRegistering: true, onComplete: device.register)
                    } else {
                        OnBoardingView(transition: proceedToRegistration)
                    }
                } else {
                    MainView()
                }
            #endif
        }.alert(isPresented: $device.hasError) {
            Alert(title: Text("Error"), message: Text(device.errorMessage!), dismissButton: .cancel(Text("Dismiss"), action: device.dismissError))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
