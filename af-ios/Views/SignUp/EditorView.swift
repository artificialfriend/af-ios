//
//  EditorView.swift
//  af-ios
//
//  Created by Ashutosh Narang on 08/01/23.
//

import SwiftUI
import UIKit

struct EditorView: View {
    @EnvironmentObject var af: AF
    @Binding var activeTab: Feature
    
    func populateTabOptions() -> OptionsView {
        var activeTabOptionsView: OptionsView
        
        switch activeTab {
        case .skin:
            activeTabOptionsView = OptionsView(feature: .skin, row1Label: "Color", row1Options: skinColors, row1ActiveOption: af.skinColor, row2Label: "Freckles", row2Options: skinFreckles, row2ActiveOption: af.freckles)
        case .hair:
            activeTabOptionsView = OptionsView(feature: .hair, row1Label: "Color", row1Options: hairColors, row1ActiveOption: af.hairColor, row2Label: "Styles", row2Options: hairStyles, row2ActiveOption: af.hairStyle)
        case .eyes:
            activeTabOptionsView = OptionsView(feature: .eyes, row1Label: "Color", row1Options: eyeColors, row1ActiveOption: af.eyeColor, row2Label: "Lashes", row2Options: eyeLashes, row2ActiveOption: af.lashes)
        case .bubble:
            activeTabOptionsView = OptionsView(feature: .eyes, row1Label: "Color", row1Options: bubbleColors, row1ActiveOption: af.bubbleColor, row2Label: "None", row2Options: bubbleColors, row2ActiveOption: bubbleColors[0])
        }
        
        return activeTabOptionsView
    }
    
    var body: some View {
        VStack(spacing: 0) {
            DividerView()

            TabsView(activeTab: $activeTab)
            
            DividerView()
            
            populateTabOptions()
            
            DividerView()
        }
        .padding(.top, 32)
        .padding(.bottom, 12)
    }
}

struct TabsView: View {
    @Binding var activeTab: Feature
    
    var body: some View {
        HStack(spacing: 0) {
            Spacer()
            
            TabLabelView(label: "Skin", feature: .skin, activeTab: $activeTab)
            
            Spacer()
            
            TabLabelView(label: "Hair", feature: .hair, activeTab: $activeTab)
            
            Spacer()
            
            TabLabelView(label: "Eyes", feature: .eyes, activeTab: $activeTab)
            
            Spacer()
            
            TabLabelView(label: "Bubble", feature: .bubble, activeTab: $activeTab)
            
            Spacer()
        }
        .padding(.horizontal, 24)
        .frame(height: 48)
    }
}

struct TabLabelView: View {
    let label: String
    let feature: Feature
    @Binding var activeTab: Feature
    
    var body: some View {
        Button(action: {
            self.activeTab = feature
            impactMedium.impactOccurred()
        }) {
            Text(label)
                .font(activeTab == feature ? .h3 : .s)
                .foregroundColor(.afBlack)
                .opacity(activeTab == feature ? 1 : 0.5)
                .frame(width: 80)
                .animation(.easeIn(duration: 0.02), value: activeTab == feature)
        }
        .buttonStyle(Plain())
    }
}

struct OptionsView: View {
    let feature: Feature
    let row1Label: String
    let row1Options: [Option]
    var row1ActiveOption: Option
    let row2Label: String
    let row2Options: [Option]
    var row2ActiveOption: Option
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            OptionRowView(rowLabel: row1Label, rowOptions: row1Options, activeOption: row1ActiveOption)
            
            if row2Label != "None" {
                OptionRowView(rowLabel: row2Label, rowOptions: row2Options, activeOption: row2ActiveOption)
            } else {
                Spacer()
            }
        }
        .frame(height: 257)
        .padding(.bottom, 24)
    }
}

struct OptionRowView: View {
    @EnvironmentObject var af: AF
    let rowLabel: String
    let rowOptions: [Option]
    var activeOption: Option
    
    func setActiveOption(optionType: OptionType, option: Option) {
        switch optionType {
        case .skinColor:
            af.skinColor = option
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
        case .bubbleColor:
            af.bubbleColor = option
        }
   }
    
    var body: some View {
        Text(rowLabel)
            .font(.xs)
            .textCase(.uppercase)
            .opacity(0.75)
            .padding(.horizontal, 12)
            .padding(.top, 16)
            .padding(.bottom, 8)
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(rowOptions, id: \.name) { option in
                    Button(action: {
                        setActiveOption(optionType: option.optionType, option: option)
                        impactMedium.impactOccurred()
                    }) {
                        OptionView(name: option.name, optionType: option.optionType, activeOption: activeOption)
                    }
                    .buttonStyle(Plain())
                }
            }
            .padding(.horizontal, 12)
        }
        .frame(height: 88)
    }
}

struct OptionView: View {
    let name: String
    let optionType: OptionType
    var activeOption: Option
    
    var body: some View {
        ZStack {
            Image("Option")
        }
        .background(Color.afGray)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.afBlack.opacity(activeOption.name == name ? 0.8 : 0.1), lineWidth: activeOption.name == name ? 3 : 2)
                .frame(width: activeOption.name == name ? 85 : 86, height: activeOption.name == name ? 85: 86)
        )
        .frame(width: 88, height: 88)
        .animation(.easeIn(duration: 0.05), value: activeOption.name == name)
    }
}

