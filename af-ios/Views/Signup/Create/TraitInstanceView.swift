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
    let instance: any TraitInstance
    let width = traitInstanceWidth
    var activeInstance: any TraitInstance
    
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
                .stroke(activeInstance.name == instance.name ? af.af.interface.userColor : setOptionElements().2, lineWidth: activeInstance.name == instance.name ? 2.5 : 2)
                .frame(width: activeInstance.name == instance.name ? width - 2.5 : width - 2, height: activeInstance.name == instance.name ? width - 2.5 : width - 2)
        )
        .frame(width: width, height: width)
        .animation(.linear(duration: 0.1), value: activeInstance.name == instance.name)
    }
    
    func setOptionElements() -> (Image, Color, Color) {
        if instance.trait == .skinColor {
            let interface = Interface.allCases.first(where: { $0.name == instance.name })!
            return (interface.afImage, interface.afColor, interface.lineColor)
        } else {
            return (af.af.interface.afImage, af.af.interface.afColor, af.af.interface.lineColor)
        }
    }
}

struct TraitInstanceView_Previews: PreviewProvider {
    static var previews: some View {
        TraitInstanceView(instance: SkinColor.green, activeInstance: SkinColor.green)
            .environmentObject(AFState())
    }
}
