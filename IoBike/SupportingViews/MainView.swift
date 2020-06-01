//
//  MainView.swift
//  IoBike
//
//  Created by James Lemkin on 5/13/20.
//  Copyright © 2020 James Lemkin. All rights reserved.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var device : Device
    
    var body: some View {
        ZStack {
            VStack(spacing: 0.0) {
                Text(device.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding(.all)
                    .padding(.top, 50)
                    .background(Color.appThemeBlue)
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                MapView()
            }
            
            VStack {
                Spacer()
                ModalView().padding(.bottom, 70)
            }
        }.edgesIgnoringSafeArea(.all)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

extension Color {
    static var appThemeBlue: Color {
        Color(red: 0.196, green: 0.404, blue:0.533)
    }
}
