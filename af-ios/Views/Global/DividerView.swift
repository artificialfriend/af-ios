//
//  DividerView.swift
//  af-ios
//
//  Created by Ashutosh Narang on 08/01/23.
//

import SwiftUI

struct DividerView: View {
    @EnvironmentObject var af: AFState
    
    var body: some View {
        Rectangle()
            .fill(af.interface.lineColor)
            .frame(height: s1_5)
            .edgesIgnoringSafeArea(.horizontal)
    }
}
