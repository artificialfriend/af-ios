//
//  AFView.swift
//  af-ios
//
//  Created by Ashutosh Narang on 08/01/23.
//

import SwiftUI

struct AFView: View {
    @EnvironmentObject var af: AF
    let width = UIScreen.main.bounds.width * 0.075
    
    var body: some View {
        ZStack {
            ZStack {
                Circle()
                    .shadow(
                        color: af.interface.bubbleColor.opacity(0.5),
                        radius: width,
                        x: s0,
                        y: width
                    )
                    
                Circle()
                    .blendMode(.destinationOut)
            }
            .compositingGroup()
            
            Circle()
                .fill(af.interface.bubbleColor).opacity(0.3)
                
            af.interface.afImage
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            af.interface.bubbleImage
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        .frame(maxWidth: 400)
        .aspectRatio(contentMode: .fit)
    }
}
