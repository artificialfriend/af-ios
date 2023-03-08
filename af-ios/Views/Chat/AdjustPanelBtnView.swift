//
//  AdjustPanelBtnView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-02-27.
//

import SwiftUI

struct AdjustPanelBtnView: View {
    @EnvironmentObject var af: AFOO
    let adjustOption: AdjustOption
    
    var body: some View {
        HStack {
            Spacer()
            Text(adjustOption.string)
                .font(.s)
                .textCase(.uppercase)
                .foregroundColor(.afMedBlack)
            Spacer()
        }
        .frame(height: s40)
        .overlay(
            RoundedRectangle(cornerRadius: cr24)
                .stroke(af.af.interface.lineColor, lineWidth: s1_5)
        )
    }
}

//struct AdjustPanelButtonView_Previews: PreviewProvider {
//    static var previews: some View {
//        AdjustPanelButtonView()
//    }
//}
