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
            af.af.skinColor = option
            let interfaceName = af.af.skinColor.name.components(separatedBy: " ").first
            let interfaceIndex = interfaces.firstIndex(where: {$0.name == interfaceName})
            af.af.interface = interfaces[interfaceIndex!]
            case .freckles:
            af.af.freckles = option
            case .hairColor:
            af.af.hairColor = option
            case .hairStyle:
            af.af.hairStyle = option
            case .eyeColor:
            af.af.eyeColor = option
            case .eyeLashes:
            af.af.eyeLashes = option
        }
    }
}

struct OptionRowView_Previews: PreviewProvider {
    static var previews: some View {
        OptionRowView(rowLabel: "Label", rowOptions: skinColors, activeOption: skinColors[1])
            .environmentObject(AFState())
    }
}
