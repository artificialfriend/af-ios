//
//  TraitInstanceRowView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-02-04.
//

import SwiftUI

struct TraitInstanceRowView: View {
    @EnvironmentObject var af: AFState
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
            af.af.interface = Interface.allCases.first(where: { $0.name == instance.name })!
            af.storeAF()
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
        case .interface:
            return
        }
    }
}

struct TraitInstanceRowView_Previews: PreviewProvider {
    static var previews: some View {
        TraitInstanceRowView(label: "Label", activeInstance: SkinColor.green)
            .environmentObject(AFState())
    }
}
