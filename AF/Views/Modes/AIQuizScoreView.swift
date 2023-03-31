//
//  AIQuizScoreView.swift
//  AF
//
//  Created by Cam Crain on 2023-03-31.
//

import SwiftUI

struct AIQuizScoreView: View {
    @EnvironmentObject var af: AFOO
    
    var body: some View {
        VStack {
            Text("SCORE")
                .font(.sixteenBold)
                .foregroundColor(af.af.interface.medColor)
            
            Text("3/3")
                .font(.sixtyfour)
                .foregroundColor(af.af.interface.darkColor.opacity(0.9))
        }
    }
}
