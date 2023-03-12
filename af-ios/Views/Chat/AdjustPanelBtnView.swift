//
//  AdjustPanelBtnView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-02-27.
//

import SwiftUI

struct AdjustPanelBtnView: View {
    @EnvironmentObject var af: AFOO
    @Binding var isActive: Bool
    let adjustOption: AdjustOption
    
    var body: some View {
        ZStack {
            HStack {
                Spacer()
                Text(adjustOption.string)
                    .font(.fourteenBold)
                    .foregroundColor(isActive ? .white : .afBlack)
                    .animation(.linear1, value: isActive)
                Spacer()
            }
            .frame(height: 36)
            .background(
                RoundedRectangle(cornerRadius: s8)
                    .fill(isActive ? af.af.interface.userColor : af.af.interface.afColor2)
                    .animation(.linear1, value: isActive)
                    //.stroke(af.af.interface.lineColor, lineWidth: s1_5)
                    .cornerRadius(adjustOption == .short || adjustOption == .simple ? 18 : cr8, corners: .topLeft)
                    .cornerRadius(adjustOption == .long || adjustOption == .academic ? 18 : cr8, corners: .topRight)
                    .cornerRadius(adjustOption == .short || adjustOption == .casual ? 18 : cr8, corners: .bottomLeft)
                    .cornerRadius(adjustOption == .long || adjustOption == .professional ? 18 : cr8, corners: .bottomRight)
            )
            
        }
        .frame(height: 36)
    }
}

//struct AdjustPanelButtonView_Previews: PreviewProvider {
//    static var previews: some View {
//        AdjustPanelButtonView()
//    }
//}
