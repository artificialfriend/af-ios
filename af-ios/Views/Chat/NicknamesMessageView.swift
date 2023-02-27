//
//  NicknamesMessageView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-02-27.
//

import SwiftUI

struct NicknamesMessageView: View {
    @EnvironmentObject var af: AFOO
    
    var body: some View {
        HStack(spacing: s0) {
            VStack{
                NicknameView(nickname: "bro")
            }
//            .background {
//                GeometryReader { geo in
//                    Color.clear
//                        .onAppear {
//                            setTextWidth(geo: geo.size.width, isOnAppear: true)
//                        }
//                        .onChange(of: text) { _ in
//                            setTextWidth(geo: geo.size.width, isOnAppear: false)
//                        }
//                }
//            }
            .font(.p)
            .padding(.horizontal, s16)
            .padding(.vertical, s12)
            .frame(alignment: .bottomLeading)
            .background(af.af.interface.afColor)//backgroundColor)
            .cornerRadius(s24, corners: .topRight)
            .cornerRadius(s24, corners: .topLeft)
            .cornerRadius(s24, corners: .bottomRight)
            .cornerRadius(s8, corners: .bottomLeft)
            .padding(.leading, s12)
            .padding(.trailing, s64)
            //.onAppear { backgroundColor = af.af.interface.afColor }
            
            Spacer(minLength: 0)
        }
        //.opacity(isNew ? opacity : 1)
        .padding(.top, s8)
        .padding(.bottom, 0)//bottomPadding)
//        .onAppear {
//            if isNew {
//                loadMessage()
//            }
//        }
    }
}

//struct NicknamesMessageView_Previews: PreviewProvider {
//    static var previews: some View {
//        NicknamesMessageView()
//    }
//}
