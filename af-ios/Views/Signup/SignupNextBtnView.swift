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
    @Binding var welcomeLabelOpacity: Double
    @Binding var isLoading: Bool
    @Binding var spinnerRotation: Angle
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cr16)
                .fill(Color.afBlack)
            
            Text("Get Started")
                .opacity(welcomeLabelOpacity)
            
            Text("Next")
                .opacity(createOpacity)
            
            Text("Boot Up")
                .opacity(nameOpacity)
        }
        .font(.l)
        .foregroundColor(.white)
    }
}
