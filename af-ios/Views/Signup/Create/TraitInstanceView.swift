//
//  TraitInstanceView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-02-04.
//

import SwiftUI

let traitInstanceWidth = (UIScreen.main.bounds.width - s48) / 4.25

struct TraitInstanceView: View {
    @EnvironmentObject var af: AFState
    
    let traitInstance: any TraitInstance
    let width = traitInstanceWidth
    var activeTraitInstance: any TraitInstance
    
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
                .stroke(activeTraitInstance.name == traitInstance.name ? af.af.interface.userColor : setOptionElements().2, lineWidth: activeTraitInstance.name == traitInstance.name ? 2.5 : 2)
                .frame(width: activeTraitInstance.name == traitInstance.name ? width - 2.5 : width - 2, height: activeTraitInstance.name == traitInstance.name ? width - 2.5 : width - 2)
        )
        .frame(width: width, height: width)
        .animation(.linear(duration: 0.1), value: activeTraitInstance.name == traitInstance.name)
    }
    
    func setOptionElements() -> (Image, Color, Color) {
        if traitInstance.trait == .skinColor {
            let interface = Interface.allCases.first(where: { $0.name == traitInstance.name })!
            return (interface.afImage, interface.afColor, interface.lineColor)
        } else {
            return (af.af.interface.afImage, af.af.interface.afColor, af.af.interface.lineColor)
        }
    }
}

struct TraitInstanceView_Previews: PreviewProvider {
    static var previews: some View {
        TraitInstanceView(traitInstance: SkinColor.green, activeTraitInstance: SkinColor.green)
            .environmentObject(AFState())
    }
}
