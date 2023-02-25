//
//  SignupBackButtonView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-02-24.
//

import SwiftUI

struct SignupBackButtonView: View {
    @Binding var currentSignupStep: SignupStep
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cr16)
                .fill(Color.afGray)
            
            Image("BackIcon")
                .foregroundColor(.afBlack.opacity(0.5))
        }
        .frame(width: s64)
        .padding(.leading, currentSignupStep == .name || currentSignupStep == .bootup ? s0 : -s72)
        .padding(.trailing, currentSignupStep == .name || currentSignupStep == .bootup ? s8 : s0)
        .opacity(currentSignupStep == .name || currentSignupStep == .bootup ? 1 : 0)
    }
}

//struct SignupBackButtonView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignupBackButtonView(currentSignupStep: $currentSignupStep)
//    }
//}
