//
//  AdjustPanelLabelView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-02-27.
//

import SwiftUI

struct AdjustPanelLabelView: View {
    let label: String
    
    var body: some View {
        Text(label)
            .font(.s)
            .foregroundColor(.black)
            .padding(.bottom, s8)
    }
}

//struct AdjustPanelLabelView_Previews: PreviewProvider {
//    static var previews: some View {
//        AdjustPanelLabelView()
//    }
//}
