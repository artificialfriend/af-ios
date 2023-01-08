//
//  DividerView.swift
//  af-ios
//
//  Created by Ashutosh Narang on 08/01/23.
//

import SwiftUI

struct DividerView: View {
    var body: some View {
        Rectangle()
            .fill(Color.afBlack)
            .opacity(0.1)
            .frame(height: 1.5)
            .edgesIgnoringSafeArea(.horizontal)
    }
}
