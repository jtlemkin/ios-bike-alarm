//
//  SuccessView.swift
//  IoBike
//
//  Created by James Lemkin on 5/13/20.
//  Copyright © 2020 James Lemkin. All rights reserved.
//

import SwiftUI

struct SuccessView: View {
    var body: some View {
        VStack {
            Image(systemName: "checkmark.circle")
                .resizable()
                .frame(width: 200, height: 200)
                .foregroundColor(.white)
            
            Text("Success!")
                .font(.title)
                .foregroundColor(.white)
        }
    }
}

struct SuccessView_Previews: PreviewProvider {
    static var previews: some View {
        SuccessView()
    }
}
