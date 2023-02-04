//
//  OptionView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-02-04.
//

import SwiftUI

struct OptionView: View {
    @EnvironmentObject var af: AFState
    
    let name: String
    let optionType: OptionType
    let width = optionWidth
    var activeOption: Option
    
    var body: some View {
        ZStack {
            setOptionElements().0
                .resizable()
                .frame(width: width * 1.05, height: width * 1.05)
                .frame(width: width, height: width)
                .clipped()
        }
        .background(setOptionElements().1)
        .cornerRadius(cr16)
        .overlay(
            RoundedRectangle(cornerRadius: cr16)
                .stroke(activeOption.name == name ? af.interface.userColor : setOptionElements().2, lineWidth: activeOption.name == name ? 2.5 : 2)
                .frame(width: activeOption.name == name ? width - 2.5 : width - 2, height: activeOption.name == name ? width - 2.5 : width - 2)
        )
        .frame(width: width, height: width)
        .animation(.linear(duration: 0.1), value: activeOption.name == name)
    }
    
    func setOptionElements() -> (Image, Color, Color) {
        if optionType == .skinColor {
            if name == "Green Skin" {
                return (interfaces[0].afImage, interfaces[0].afColor, interfaces[0].lineColor)
            } else if name == "Blue Skin" {
                return (interfaces[1].afImage, interfaces[1].afColor, interfaces[1].lineColor)
            } else if name == "Purple Skin" {
                return (interfaces[2].afImage, interfaces[2].afColor, interfaces[2].lineColor)
            } else if name == "Pink Skin" {
                return (interfaces[3].afImage, interfaces[3].afColor, interfaces[3].lineColor)
            }
        }
        
        return (af.interface.afImage, af.interface.afColor, af.interface.lineColor)
    }
}

struct OptionView_Previews: PreviewProvider {
    static var previews: some View {
        OptionView(name: skinFreckles[0].name, optionType: skinFreckles[0].optionType, activeOption: skinFreckles[0])
            .environmentObject(AFState())
    }
}
