//
//  SettingsRow.swift
//  IoBike
//
//  Created by James Lemkin on 5/3/20.
//  Copyright © 2020 James Lemkin. All rights reserved.
//

import SwiftUI

struct SettingsRow: View {
    var imageName : String
    var text : String
    var action : () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit).frame(width: 30.0, height: 30.0)
                Text(text)
                Spacer()
            }
        }
    }
}

struct SettingsRow_Previews: PreviewProvider {
    static var previews: some View {
        SettingsRow(imageName: "person", text: /*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/, action: {})
    }
}
