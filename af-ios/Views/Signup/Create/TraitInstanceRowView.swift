//
//  TraitInstanceRowView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-02-04.
//

import SwiftUI

struct TraitInstanceRowView: View {
    @EnvironmentObject var af: AFState
    
    let traitLabel: String
    var activeTraitInstance: any TraitInstance
    
    var body: some View {
        Text(traitLabel)
            .font(.s)
            .foregroundColor(.afBlack)
            .padding(.horizontal, s12)
            .padding(.top, s12)
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: s8) {
                if activeTraitInstance.trait == .skinColor {
                    ForEach(SkinColor.allCases, id: \.self) { traitInstance in
                        Button(action: { handleTap(traitInstance: traitInstance) }) {
                            TraitInstanceView(traitInstance: traitInstance, activeTraitInstance: activeTraitInstance)
                        }
                        .buttonStyle(Spring())
                    }
                } else if activeTraitInstance.trait == .freckles {
                    ForEach(Freckles.allCases, id: \.self) { traitInstance in
                        Button(action: { handleTap(traitInstance: traitInstance) }) {
                            TraitInstanceView(traitInstance: traitInstance, activeTraitInstance: activeTraitInstance)
                        }
                        .buttonStyle(Spring())
                    }
                } else if activeTraitInstance.trait == .hairColor {
                    ForEach(HairColor.allCases, id: \.self) { traitInstance in
                        Button(action: { handleTap(traitInstance: traitInstance) }) {
                            TraitInstanceView(traitInstance: traitInstance, activeTraitInstance: activeTraitInstance)
                        }
                        .buttonStyle(Spring())
                    }
                } else if activeTraitInstance.trait == .hairstyle {
                    ForEach(Hairstyle.allCases, id: \.self) { traitInstance in
                        Button(action: { handleTap(traitInstance: traitInstance) }) {
                            TraitInstanceView(traitInstance: traitInstance, activeTraitInstance: activeTraitInstance)
                        }
                        .buttonStyle(Spring())
                    }
                } else if activeTraitInstance.trait == .eyeColor {
                    ForEach(EyeColor.allCases, id: \.self) { traitInstance in
                        Button(action: { handleTap(traitInstance: traitInstance) }) {
                            TraitInstanceView(traitInstance: traitInstance, activeTraitInstance: activeTraitInstance)
                        }
                        .buttonStyle(Spring())
                    }
                } else if activeTraitInstance.trait == .eyelashes {
                    ForEach(Eyelashes.allCases, id: \.self) { traitInstance in
                        Button(action: { handleTap(traitInstance: traitInstance) }) {
                            TraitInstanceView(traitInstance: traitInstance, activeTraitInstance: activeTraitInstance)
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
        setActiveTraitInstance(traitInstance: traitInstance)
    }
    
    func setActiveTraitInstance(traitInstance: any TraitInstance) {
        switch traitInstance.trait {
        case .skinColor:
            af.af.skinColor = traitInstance as! SkinColor
            af.af.interface = Interface.allCases.first(where: { $0.name == traitInstance.name })!
            af.storeAF()
        case .freckles:
            af.af.freckles = traitInstance as! Freckles
        case .hairColor:
            af.af.hairColor = traitInstance as! HairColor
        case .hairstyle:
            af.af.hairstyle = traitInstance as! Hairstyle
        case .eyeColor:
            af.af.eyeColor = traitInstance as! EyeColor
        case .eyelashes:
            af.af.eyelashes = traitInstance as! Eyelashes
        case .interface:
            return
        }
    }
}

struct TraitInstanceRowView_Previews: PreviewProvider {
    static var previews: some View {
        TraitInstanceRowView(traitLabel: "Label", activeTraitInstance: SkinColor.green)
            .environmentObject(AFState())
    }
}
