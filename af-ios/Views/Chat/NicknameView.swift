//
//  NicknameView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-02-27.
//

import SwiftUI

struct NicknameView: View {
    @EnvironmentObject var user: UserOO
    @EnvironmentObject var af: AFOO
    @State private var isSelected: Bool = false
    @State private var bgOpacity: Double = 0
    @State private var strokeOpacity: Double = 1
    let nickname: Nickname
    
    var body: some View {
        Button(action: { handleBtnTap() }) {
            Text(nickname.name)
                .font(.p)
                .foregroundColor(isSelected ? .white : .afMedBlack)
                .padding(.horizontal, s16)
                .frame(height: s32)
                .background(af.af.interface.userColor.opacity(bgOpacity))
                .cornerRadius(cr16)
                .overlay(
                    Capsule()
                        .stroke(af.af.interface.lineColor, lineWidth: s1_5)
                        .opacity(strokeOpacity)
                )
                .animation(.linear0_5, value: isSelected)
        }
        .buttonStyle(Spring())
    }
    
    func handleBtnTap() {
        impactMedium.impactOccurred()
        
        if isSelected {
            let nicknameIndex = user.user.nicknames.firstIndex(where: {$0.name == nickname.name})!
            user.user.nicknames.remove(at: nicknameIndex)
            isSelected = false
            bgOpacity = 0
            strokeOpacity = 1
        } else {
            user.user.nicknames.append(nickname)
            isSelected = true
            bgOpacity = 1
            strokeOpacity = 0
        }
    }
}

//struct NicknameView_Previews: PreviewProvider {
//    static var previews: some View {
//        NicknameView()
//    }
//}
