//
//  MenuItemView.swift
//  AF
//
//  Created by Cam Crain on 2023-03-28.
//

import SwiftUI

struct MenuItemView: View {
    @EnvironmentObject var af: AFOO
    let icon: Image
    let name: String
    
    var body: some View {
        HStack {
            icon
                .resizable()
                .foregroundColor(af.af.interface.medColor)
                .frame(width: s20, height: s20)
            
            Text(name)
                .font(.s)
                .foregroundColor(.afBlack)
        }
    }
}
