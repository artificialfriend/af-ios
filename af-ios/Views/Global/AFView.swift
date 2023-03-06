//
//  AFView.swift
//  af-ios
//
//  Created by Ashutosh Narang on 08/01/23.
//

import SwiftUI

struct AFView: View {
    @EnvironmentObject var af: AFOO
    @State private var shadowRadius = UIScreen.main.bounds.width * 0.075
    @State private var afImage: TraitInstanceImage = .green1
    
    var body: some View {
        ZStack {
            ZStack {
                Circle()
                    .background {
                        GeometryReader { geo in
                            Color.clear
                                .onAppear {
                                    shadowRadius = geo.size.width / 12
                                }
                        }
                    }
                    .shadow(
                        color: af.af.interface.bubbleColor.opacity(0.3),
                        radius: shadowRadius,
                        x: s0,
                        y: shadowRadius / 1
                    )
                    
                Circle()
                    .blendMode(.destinationOut)
            }
            .compositingGroup()
            
            Circle()
                .fill(af.af.interface.bubbleColor).opacity(0.3)
                .background(Blur())
                .clipShape(Circle())
                
            af.af.image.neutral
            //setAFImage()
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            af.af.bubble.image
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        //.animation(.linear(duration: 0.5), value: af.af.skinColor)
        .frame(maxWidth: 400)
        .aspectRatio(contentMode: .fit)
    }
}

struct AFView_Previews: PreviewProvider {
    static var previews: some View {
        AFView()
            .environmentObject(AFOO())
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
    }
}
