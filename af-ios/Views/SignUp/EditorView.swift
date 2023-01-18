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
    
    var body: some View {
        VStack(spacing: 0) {
            DividerView()

            TabsView(activeTab: $activeTab)
            
            DividerView()
            
            OptionsView(activeTab: $activeTab)
            
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
            TabLabelView(label: "Skin", feature: .skin, activeTab: $activeTab)
            TabLabelView(label: "Hair", feature: .hair, activeTab: $activeTab)
            TabLabelView(label: "Eyes", feature: .eyes, activeTab: $activeTab)
        }
        .frame(height: 48)
    }
}

struct TabLabelView: View {
    @EnvironmentObject var af: AF
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
                .foregroundColor(activeTab == feature ? .afBlack : af.interface.iconColor)
                .opacity(activeTab == feature ? 1 : 0.5)
                .frame(width: 80)
                .animation(.easeIn(duration: 0.02), value: activeTab == feature)
        }
        .buttonStyle(Plain())
    }
}

struct OptionsView: View {
    @EnvironmentObject var af: AF
    @Binding var activeTab: Feature
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                OptionRowView(rowLabel: "Color", rowOptions: skinColors, activeOption: af.skinColor)
                OptionRowView(rowLabel: "Freckles", rowOptions: skinFreckles, activeOption: af.freckles)
            }
            .opacity(activeTab == .skin ? 1 : 0)
            
            VStack(alignment: .leading, spacing: 0) {
                OptionRowView(rowLabel: "Color", rowOptions: hairColors, activeOption: af.hairColor)
                OptionRowView(rowLabel: "Style", rowOptions: hairStyles, activeOption: af.hairStyle)
            }
            .opacity(activeTab == .hair ? 1 : 0)
            
            VStack(alignment: .leading, spacing: 0) {
                OptionRowView(rowLabel: "Color", rowOptions: eyeColors, activeOption: af.eyeColor)
                OptionRowView(rowLabel: "Lashes", rowOptions: eyeLashes, activeOption: af.lashes)
            }
            .opacity(activeTab == .eyes ? 1 : 0)
        }
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
    
    var body: some View {
        Text(rowLabel)
            .font(.s)
            .foregroundColor(.afBlack)
            .padding(.horizontal, 12)
            .padding(.top, 16)
            .padding(.bottom, 4)
        
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
        .frame(height: (UIScreen.main.bounds.width - 48) / 4.25)
    }
}

struct OptionView: View {
    @EnvironmentObject var af: AF
    let name: String
    let optionType: OptionType
    let width = (UIScreen.main.bounds.width - 48) / 4.25
    var activeOption: Option
    
    func setOptionElements() -> (Image, Color, Color) {
        if optionType == .skinColor {
            if name == "Green Skin" {
                return (interfaces[0].afImage, interfaces[0].afColor, interfaces[0].lineColor)
            } else if name == "Blue Skin" {
                return (interfaces[1].afImage, interfaces[1].afColor, interfaces[1].lineColor)
            } else if name == "Purple Skin" {
                return (interfaces[2].afImage, interfaces[2].afColor, interfaces[2].lineColor)
            } else if name == "Pink Skin" {
                return (interfaces[3].afImage, interfaces[3].afColor, interfaces[3].lineColor)
            }
        }
        
        return (af.interface.afImage, af.interface.afColor, af.interface.lineColor)
    }
    
    var body: some View {
        ZStack {
            setOptionElements().0
                .resizable()
                .frame(width: width * 1.05, height: width * 1.05)
                .frame(width: width, height: width)
                .clipped()
        }
        .background(setOptionElements().1)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(activeOption.name == name ? af.interface.userColor : setOptionElements().2, lineWidth: activeOption.name == name ? 2.5 : 2)
                .frame(width: activeOption.name == name ? width - 2.5 : width - 2, height: activeOption.name == name ? width - 2.5 : width - 2)
        )
        .frame(width: width, height: width)
        .animation(.easeIn(duration: 0.05), value: activeOption.name == name)
    }
}

struct EditorView_Previews: PreviewProvider {
    @State static var activeTab: Feature = .skin
    
    static var previews: some View {
        EditorView(activeTab: $activeTab)
            .environmentObject(AF())
            .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
        
        EditorView(activeTab: $activeTab)
            .environmentObject(AF())
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro Max"))
    }
}
