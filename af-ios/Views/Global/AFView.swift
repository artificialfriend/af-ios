//
//  AFView.swift
//  af-ios
//
//  Created by Ashutosh Narang on 08/01/23.
//

import SwiftUI

struct AFView: View {
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ZStack {
                    Circle()
                        .shadow(
                            color: Color(hue: 190/360, saturation: 1, brightness: 1).opacity(0.5),
                            radius: geo.size.width * 0.075,
                            x: 0,
                            y: geo.size.width * 0.075
                        )
                    Circle()
                        .blendMode(.destinationOut)
                }
                .compositingGroup()
                
                Circle()
                    .fill(Color.afBubbleBlue.opacity(0.6))
                    
                Image("Memoji")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                Image("BlueBubble")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
        .frame(maxWidth: 400)
        .aspectRatio(contentMode: .fit)
    }
}

struct BubbleView_Previews: PreviewProvider {
    static var previews: some View {
        AFView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
    }
}

