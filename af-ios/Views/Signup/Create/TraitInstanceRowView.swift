//
//  TraitInstanceRowView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-02-04.
//

import SwiftUI

struct TraitInstanceRowView: View {
    @EnvironmentObject var af: AFOO
    let label: String
    var activeInstance: any TraitInstance
    
    var body: some View {
        Text(label)
            .font(.s)
            .foregroundColor(.afBlack)
            .padding(.horizontal, s12)
            .padding(.top, s12)
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: s8) {
                if activeInstance.trait == .skinColor {
                    ForEach(SkinColor.allCases, id: \.self) { traitInstance in
                        Button(action: { handleTap(traitInstance: traitInstance) }) {
                            TraitInstanceView(instance: traitInstance, activeInstance: activeInstance)
                        }
                        .buttonStyle(Spring())
                    }
                } else if activeInstance.trait == .freckles {
                    ForEach(Freckles.allCases, id: \.self) { traitInstance in
                        Button(action: { handleTap(traitInstance: traitInstance) }) {
                            TraitInstanceView(instance: traitInstance, activeInstance: activeInstance)
                        }
                        .buttonStyle(Spring())
                    }
                } else if activeInstance.trait == .hairColor {
                    ForEach(HairColor.allCases, id: \.self) { traitInstance in
                        Button(action: { handleTap(traitInstance: traitInstance) }) {
                            TraitInstanceView(instance: traitInstance, activeInstance: activeInstance)
                        }
                        .buttonStyle(Spring())
                    }
                } else if activeInstance.trait == .hairstyle {
                    ForEach(Hairstyle.allCases, id: \.self) { traitInstance in
                        Button(action: { handleTap(traitInstance: traitInstance) }) {
                            TraitInstanceView(instance: traitInstance, activeInstance: activeInstance)
                        }
                        .buttonStyle(Spring())
                    }
                } else if activeInstance.trait == .eyeColor {
                    ForEach(EyeColor.allCases, id: \.self) { traitInstance in
                        Button(action: { handleTap(traitInstance: traitInstance) }) {
                            TraitInstanceView(instance: traitInstance, activeInstance: activeInstance)
                        }
                        .buttonStyle(Spring())
                    }
                } else if activeInstance.trait == .eyelashes {
                    ForEach(Eyelashes.allCases, id: \.self) { traitInstance in
                        Button(action: { handleTap(traitInstance: traitInstance) }) {
                            TraitInstanceView(instance: traitInstance, activeInstance: activeInstance)
                        }
                        .buttonStyle(Spring())
                    }
                }
            }
            .padding(.horizontal, s12)
            .padding(.vertical, 4)
        }
    }
    
    func handleTap(traitInstance: any TraitInstance) {
        impactMedium.impactOccurred()
        setActiveInstance(to: traitInstance)
    }
    
    func setActiveInstance(to instance: any TraitInstance) {
        switch instance.trait {
        case .skinColor:
            af.af.skinColor = instance as! SkinColor
            af.af.bubble = Bubble.allCases.first(where: { $0.name == instance.name })!
            af.af.interface = Interface.allCases.first(where: { $0.name == instance.name })!
        case .freckles:
            af.af.freckles = instance as! Freckles
        case .hairColor:
            af.af.hairColor = instance as! HairColor
        case .hairstyle:
            af.af.hairstyle = instance as! Hairstyle
        case .eyeColor:
            af.af.eyeColor = instance as! EyeColor
        case .eyelashes:
            af.af.eyelashes = instance as! Eyelashes
        case .image:
            return
        case .bubble:
            return
        case .interface:
            return
        }
        
        setAFImage()
    }
    
    func setAFImage() {
        if af.af.skinColor == .green && af.af.hairstyle == .one { af.af.image = .green1 }
        else if af.af.skinColor == .green && af.af.hairstyle == .two { af.af.image = .green2 }
        else if af.af.skinColor == .green && af.af.hairstyle == .three { af.af.image = .green3 }
        else if af.af.skinColor == .green && af.af.hairstyle == .four { af.af.image = .green4 }
        else if af.af.skinColor == .blue && af.af.hairstyle == .one { af.af.image = .blue1 }
        else if af.af.skinColor == .blue && af.af.hairstyle == .two { af.af.image = .blue2 }
        else if af.af.skinColor == .blue && af.af.hairstyle == .three { af.af.image = .blue3 }
        else if af.af.skinColor == .blue && af.af.hairstyle == .four { af.af.image = .blue4 }
        else if af.af.skinColor == .purple && af.af.hairstyle == .one { af.af.image = .purple1 }
        else if af.af.skinColor == .purple && af.af.hairstyle == .two { af.af.image = .purple2 }
        else if af.af.skinColor == .purple && af.af.hairstyle == .three { af.af.image = .purple3 }
        else if af.af.skinColor == .purple && af.af.hairstyle == .four { af.af.image = .purple4 }
        else if af.af.skinColor == .pink && af.af.hairstyle == .one { af.af.image = .pink1 }
        else if af.af.skinColor == .pink && af.af.hairstyle == .two { af.af.image = .pink2 }
        else if af.af.skinColor == .pink && af.af.hairstyle == .three { af.af.image = .pink3 }
        else if af.af.skinColor == .pink && af.af.hairstyle == .four { af.af.image = .pink4 }
        else { af.af.image = .blue1 }
    }
}

struct TraitInstanceRowView_Previews: PreviewProvider {
    static var previews: some View {
        TraitInstanceRowView(label: "Label", activeInstance: SkinColor.green)
            .environmentObject(AFOO())
    }
}
