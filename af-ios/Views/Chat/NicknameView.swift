//
//  NicknameView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-02-27.
//

import SwiftUI

struct NicknameView: View {
    @EnvironmentObject var af: AFOO
    let nickname: String
    
    var body: some View {
        ZStack {
            Text(nickname)
                .padding(.horizontal, s16)
                .overlay(
                    Capsule()
                        .stroke(af.af.interface.lineColor, lineWidth: s1_5)
                )
                .frame(height: s32)
        }
    }
}

//struct NicknameView_Previews: PreviewProvider {
//    static var previews: some View {
//        NicknameView()
//    }
//}
