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
                } else {
                    ForEach(Hairstyle.allCases, id: \.self) { traitInstance in
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
        case .hairstyle:
            af.af.hairstyle = instance as! Hairstyle
        case .image:
            return
        case .bubble:
            return
        case .interface:
            return
        }
        
        af.setExpression(to: .neutral)
    }
}

struct TraitInstanceRowView_Previews: PreviewProvider {
    static var previews: some View {
        TraitInstanceRowView(label: "Label", activeInstance: SkinColor.green)
            .environmentObject(AFOO())
    }
}
