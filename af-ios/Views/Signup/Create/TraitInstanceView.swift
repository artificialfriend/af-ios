//
//  TraitInstanceView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-02-04.
//

import SwiftUI

struct TraitInstanceView: View {
    @EnvironmentObject var af: AFOO
    let instance: any TraitInstance
    let width: CGFloat = (UIScreen.main.bounds.width - s48) / 4
    var activeInstance: any TraitInstance
    
    var body: some View {
        ZStack {
            setTraitInstanceImg(instance: instance).image
                .resizable()
                .frame(width: width * 1.05, height: width * 1.05)
                .frame(width: width, height: width)
                .clipped()
        }
        .background(setTraitInstanceViewElements().0)
        .cornerRadius(cr16)
        .overlay(
            RoundedRectangle(cornerRadius: cr16)
                .stroke(activeInstance.name == instance.name ? af.af.interface.userColor : setTraitInstanceViewElements().1, lineWidth: activeInstance.name == instance.name ? 2.5 : 2)
                .frame(width: activeInstance.name == instance.name ? width - 2.5 : width - 2, height: activeInstance.name == instance.name ? width - 2.5 : width - 2)
        )
        .frame(width: width, height: width)
        .animation(nil, value: activeInstance.name == instance.name)
    }
    
    func setTraitInstanceViewElements() -> (Color, Color) {
        if instance.trait == .skinColor {
            let interface = Interface.allCases.first(where: { $0.name == instance.name })!
            return (interface.afColor, interface.lineColor)
        } else {
            return (af.af.interface.afColor, af.af.interface.lineColor)
        }
    }
    
    func setTraitInstanceImg(instance: any TraitInstance) -> AFImage {
        if instance.trait == .skinColor {
            if instance.name == "Green" && af.af.hairstyle == .one { return .green1 }
            else if instance.name == "Green" && af.af.hairstyle == .two { return .green2 }
            else if instance.name == "Green" && af.af.hairstyle == .three { return .green3 }
            else if instance.name == "Green" && af.af.hairstyle == .four { return .green4 }
            else if instance.name == "Blue" && af.af.hairstyle == .one { return .blue1 }
            else if instance.name == "Blue" && af.af.hairstyle == .two { return .blue2 }
            else if instance.name == "Blue" && af.af.hairstyle == .three { return .blue3 }
            else if instance.name == "Blue" && af.af.hairstyle == .four { return .blue4 }
            else if instance.name == "Purple" && af.af.hairstyle == .one { return .purple1 }
            else if instance.name == "Purple" && af.af.hairstyle == .two { return .purple2 }
            else if instance.name == "Purple" && af.af.hairstyle == .three { return .purple3 }
            else if instance.name == "Purple" && af.af.hairstyle == .four { return .purple4 }
            else if instance.name == "Pink" && af.af.hairstyle == .one { return .pink1 }
            else if instance.name == "Pink" && af.af.hairstyle == .two { return .pink2 }
            else if instance.name == "Pink" && af.af.hairstyle == .three { return .pink3 }
            else if instance.name == "Pink" && af.af.hairstyle == .four { return .pink4 }
        } else if instance.trait == .hairstyle {
            if af.af.skinColor == .green && instance.name == "1" { return .green1 }
            else if af.af.skinColor == .green && instance.name == "2" { return .green2 }
            else if af.af.skinColor == .green && instance.name == "3" { return .green3 }
            else if af.af.skinColor == .green && instance.name == "4" { return .green4 }
            else if af.af.skinColor == .blue && instance.name == "1" { return .blue1 }
            else if af.af.skinColor == .blue && instance.name == "2" { return .blue2 }
            else if af.af.skinColor == .blue && instance.name == "3" { return .blue3 }
            else if af.af.skinColor == .blue && instance.name == "4" { return .blue4 }
            else if af.af.skinColor == .purple && instance.name == "1" { return .purple1 }
            else if af.af.skinColor == .purple && instance.name == "2" { return .purple2 }
            else if af.af.skinColor == .purple && instance.name == "3" { return .purple3 }
            else if af.af.skinColor == .purple && instance.name == "4" { return .purple4 }
            else if af.af.skinColor == .pink && instance.name == "1" { return .pink1 }
            else if af.af.skinColor == .pink && instance.name == "2" { return .pink2 }
            else if af.af.skinColor == .pink && instance.name == "3" { return .pink3 }
            else if af.af.skinColor == .pink && instance.name == "4" { return .pink4 }
        }
        
        return .blue1
    }
}
