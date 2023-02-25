//
//  DividerView.swift
//  af-ios
//
//  Created by Ashutosh Narang on 08/01/23.
//

import SwiftUI

enum Direction {
    case horizontal
    case vertical
}

struct DividerView: View {
    @EnvironmentObject var af: AFState
    let direction: Direction
    
    var body: some View {
        if direction == .horizontal {
            Rectangle()
                .fill(af.af.interface.lineColor)
                .frame(height: s1_5)
                .edgesIgnoringSafeArea(.horizontal)
        } else {
            Rectangle()
                .fill(af.af.interface.lineColor)
                .frame(width: s1_5, height: s16)
        }
    }
}

struct DividerView_Previews: PreviewProvider {
    static var previews: some View {
        DividerView(direction: .horizontal)
            .environmentObject(AFState())
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
    }
}
