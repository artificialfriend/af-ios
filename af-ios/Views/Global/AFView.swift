//
//  AFView.swift
//  af-ios
//
//  Created by Ashutosh Narang on 08/01/23.
//

import SwiftUI

struct AFView: View {
    @EnvironmentObject var af: AFState
    
    @State var shadowRadius = UIScreen.main.bounds.width * 0.075
    
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
                        color: af.interface.bubbleColor.opacity(0.3),
                        radius: shadowRadius,
                        x: s0,
                        y: shadowRadius / 1
                    )
                    
                Circle()
                    .blendMode(.destinationOut)
            }
            .compositingGroup()
            
            Circle()
                .fill(af.interface.bubbleColor).opacity(0.3)
                .background(Blur())
                .clipShape(Circle())
                
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

struct AFView_Previews: PreviewProvider {
    static var previews: some View {
        AFView()
            .environmentObject(AFState())
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
    }
}
