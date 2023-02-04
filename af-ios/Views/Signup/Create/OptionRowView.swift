//
//  OptionRowView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-02-04.
//

import SwiftUI

struct OptionRowView: View {
    @EnvironmentObject var af: AFState
    
    let rowLabel: String
    let rowOptions: [Option]
    var activeOption: Option
    
    var body: some View {
        Text(rowLabel)
            .font(.s)
            .foregroundColor(.afBlack)
            .padding(.horizontal, s12)
            .padding(.top, s12)
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: s8) {
                ForEach(rowOptions, id: \.name) { option in
                    Button(action: { handleTap(option: option) }) {
                        OptionView(name: option.name, optionType: option.optionType, activeOption: activeOption)
                    }
                    .buttonStyle(Spring())
                }
            }
            .padding(.horizontal, s12)
            .padding(.vertical, 4)
        }
    }
    
    func handleTap(option: Option) {
        impactMedium.impactOccurred()
        setActiveOption(optionType: option.optionType, option: option)
    }
    
    func setActiveOption(optionType: OptionType, option: Option) {
        switch optionType {
            case .skinColor:
                af.skinColor = option
                
                if af.skinColor.name == "Green Skin" {
                    af.interface = interfaces[0]
                } else if af.skinColor.name == "Blue Skin" {
                    af.interface = interfaces[1]
                } else if af.skinColor.name == "Purple Skin" {
                    af.interface = interfaces[2]
                } else if af.skinColor.name == "Pink Skin" {
                    af.interface = interfaces[3]
                }
            case .skinFreckles:
                af.freckles = option
            case .hairColor:
                af.hairColor = option
            case .hairStyle:
                af.hairStyle = option
            case .eyeColor:
                af.eyeColor = option
            case .eyeLashes:
                af.lashes = option
        }
    }
}

struct OptionRowView_Previews: PreviewProvider {
    static var previews: some View {
        OptionRowView(rowLabel: "Label", rowOptions: skinColors, activeOption: skinColors[1])
            .environmentObject(AFState())
    }
}
