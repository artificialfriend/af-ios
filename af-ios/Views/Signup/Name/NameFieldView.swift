//
//  NameFieldView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-01-19.
//

import SwiftUI

struct NameFieldView: View {
    @EnvironmentObject var af: AFState
    @Binding var input: String
    @Binding var charLimit: Int
    
    var body: some View {
        ZStack {
            TextField("", text: $input)
                .placeholder(when: input.isEmpty, alignment: .center) {
                    Text(af.af.name)
                        .foregroundColor(af.af.interface.softColor)
                }
                .cornerRadius(cr16)
                .font(.l)
                .foregroundColor(.afBlack)
                .multilineTextAlignment(.center)
                .accentColor(af.af.interface.userColor)
                .frame(height: s56)
                .overlay(RoundedRectangle(cornerRadius: cr16).stroke(lineWidth: 2).foregroundColor(af.af.interface.lineColor))
            
            HStack {
                Text("NAME")
                
                Spacer()
                
                Text(String(charLimit - input.count))
                    .opacity(charLimit - input.count <= 5 ? 1 : 0)
                    .multilineTextAlignment(.trailing)
            }
            .padding(.horizontal, s16)
            .font(.xs)
            .foregroundColor(af.af.interface.softColor)
        }
    }
}

//struct NameFieldView_Previews: PreviewProvider {
//    static var previews: some View {
//        NameFieldView(input: $input, charLimit: $charLimit)
//            .environmentObject(AFState())
//            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
//    }
//}
