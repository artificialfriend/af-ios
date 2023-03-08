//
//  NicknameMsgSaveBtnView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-02-27.
//

import SwiftUI

struct NicknameMsgSaveBtnView: View {
    @EnvironmentObject var user: UserOO
    @EnvironmentObject var af: AFOO
    @State private var isDisabled: Bool = false
    @State private var label: String = "Save"
    @State private var opacity: Double = 1
    
    var body: some View {
        Button(action: { handleBtnTap() }) {
            ZStack {
                RoundedRectangle(cornerRadius: cr12)
                    .fill(af.af.interface.userColor)
                    .opacity(opacity)
                
                Text(label)
                    .foregroundColor(.white)
                    .font(.m)
            }
            .frame(height: s40)
            .animation(.linear1, value: isDisabled)
        }
        .buttonStyle(Spring())
        .disabled(isDisabled)
        .onChange(of: user.user.nicknames.count) { _ in
            toggleIsDisabled()
        }
    }
    
    func handleBtnTap() {
        impactMedium.impactOccurred()
        isDisabled = true
        label = "Saved!"
        opacity = 0.5
    }
    
    func toggleIsDisabled() {
        if isDisabled {
            isDisabled = false
            label = "Save"
            opacity = 1
        }
    }
}

//struct NicknameMsgSaveButtonView_Previews: PreviewProvider {
//    static var previews: some View {
//        NicknameMsgSaveButtonView()
//    }
//}
