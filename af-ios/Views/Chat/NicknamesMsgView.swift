//
//  NicknamesMsgView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-02-27.
//

import SwiftUI

struct NicknamesMsgView: View {
    @EnvironmentObject var user: UserOO
    @EnvironmentObject var af: AFOO
    
    var body: some View {
        HStack(spacing: s0) {
            VStack(alignment: .leading) {
                HStack {
                    NicknameView(nickname: .sis)
                    NicknameView(nickname: .bro)
                    NicknameView(nickname: .girl)
                    NicknameView(nickname: .man)
                }
                
                HStack {
                    NicknameView(nickname: .maam)
                    NicknameView(nickname: .sir)
                    NicknameView(nickname: .bestie)
                }
                
                HStack {
                    NicknameView(nickname: .pal)
                    NicknameView(nickname: .buddy)
                    NicknameView(nickname: .champ)
                }
                
                HStack {
                    NicknameView(nickname: .dudette)
                    NicknameView(nickname: .dude)
                }
                
                HStack {
                    NicknameView(nickname: .ms(user.user.familyName))
                    NicknameView(nickname: .mr(user.user.familyName))
                }
                
                HStack {
                    NicknameView(nickname: .queen)
                    NicknameView(nickname: .king)
                }
                .padding(.bottom, s8)
                
                NicknameMsgSaveBtnView()
            }
            .padding(.horizontal, s16)
            .padding(.vertical, s12)
            .background(af.af.interface.afColor)
            .cornerRadius(s24, corners: .topRight)
            .cornerRadius(s24, corners: .topLeft)
            .cornerRadius(s24, corners: .bottomRight)
            .cornerRadius(s8, corners: .bottomLeft)
            .padding(.leading, s12)
            .padding(.trailing, s64)
        }
        //.opacity(isNew ? opacity : 1)
        .padding(.top, s8)
        .padding(.bottom, 0)//bottomPadding)
//        .onAppear {
//            if isNew {
//                loadMsg()
//            }
//        }
    }
}

//struct NicknamesMsgView_Previews: PreviewProvider {
//    static var previews: some View {
//        NicknamesMsgView()
//    }
//}
