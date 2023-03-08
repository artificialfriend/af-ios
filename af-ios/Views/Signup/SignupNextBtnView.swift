//
//  SignupNextBtnView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-01-20.
//

import SwiftUI
import AuthenticationServices

struct SignupNextBtnView: View {
    @EnvironmentObject var global: GlobalOO
    @EnvironmentObject var user: UserOO
    @EnvironmentObject var af: AFOO
    @Binding var createOpacity: Double
    @Binding var nameOpacity: Double
    @Binding var buttonWelcomeLabelOpacity: Double
    @Binding var isLoading: Bool
    @Binding var spinnerRotation: Angle
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cr16)
                .fill(Color.afBlack)
            
            HStack {
                Image("AppleLogo")
                    .padding(.top, -5)
                Text("Sign Up With Apple")
            }
            .opacity(buttonWelcomeLabelOpacity)
            .animation(.linear1, value: isLoading)
            
            Image("SpinnerIcon")
                .foregroundColor(.white)
                .rotationEffect(spinnerRotation)
                .animation(.loadingSpin, value: isLoading)
                .opacity(isLoading ? 1 : 0)
                .animation(.linear1, value: isLoading)
            
            Text("Next")
                .opacity(createOpacity)
            
            Text("Boot Up")
                .opacity(nameOpacity)
        }
        .font(.l)
        .foregroundColor(.white)
    }
}

//struct SignupButtonView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignupNextButtonView()
//            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
//    }
//}
