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
    
    var body: some View {
        ZStack {
            MapView()
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)

            ModalView()
                .offset(y: 150)
        }.edgesIgnoringSafeArea(.all)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
