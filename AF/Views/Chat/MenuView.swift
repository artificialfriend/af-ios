//
//  MenuView.swift
//  AF
//
//  Created by Cam Crain on 2023-03-27.
//

import SwiftUI

struct MenuView: View {
    @EnvironmentObject var af: AFOO
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            MenuItemView(icon: Image("ShuffleIcon"), name: "Planet Study", mode: .activeReading)
            
            DividerView(direction: .horizontal)
            
            MenuItemView(icon: Image("ShuffleIcon"), name: "Story Teller", mode: .activeReading)
            
            DividerView(direction: .horizontal)
            
            MenuItemView(icon: Image("ShuffleIcon"), name: "Active Reading", mode: .activeReading)
        }
        .padding(.all, s16)
        .frame(width: 200)
        .background(Color.afBlurryWhite)
        .cornerRadius(22.5)
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(af.af.interface.lineColor, lineWidth: s1_5)
                .padding(.all, -0.5)
        )
        .padding(EdgeInsets(top: 1.5, leading: 1.5, bottom: 1.5, trailing: 1.5))
        .background(Blur())
        .cornerRadius(24)
    }
}
