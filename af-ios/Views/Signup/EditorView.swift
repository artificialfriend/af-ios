//
//  EditorView.swift
//  af-ios
//
//  Created by Ashutosh Narang on 08/01/23.
//

import SwiftUI
import UIKit

let optionWidth = (UIScreen.main.bounds.width - s48) / 4.25

struct EditorView: View {
    var body: some View {
        VStack(spacing: s0) {
            DividerView(direction: .horizontal)
            
            TabsView()
            
            DividerView(direction: .horizontal)
            
            OptionsView()
            
            DividerView(direction: .horizontal)
        }
    }
}

struct TabsView: View {
    var body: some View {
        HStack(spacing: s0) {
            TabLabelView(label: "Skin", feature: .skin)
            TabLabelView(label: "Hair", feature: .hair)
            TabLabelView(label: "Eyes", feature: .eyes)
        }
        .frame(height: s48)
    }
}

struct TabLabelView: View {
    @EnvironmentObject var af: AFState
    @EnvironmentObject var signup: SignupState
    
    let label: String
    let feature: Feature
    
    var body: some View {
        Button(action: { handleTap() }) {
            Text(label)
                .font(signup.activeCreateTab == feature ? .l : .s)
                .foregroundColor(signup.activeCreateTab == feature ? .afBlack : af.interface.medColor)
                .frame(width: s80)
                .animation(.shortSpringC, value: signup.activeCreateTab == feature)
        }
        .buttonStyle(Plain())
    }
    
    func handleTap() {
        impactMedium.impactOccurred()
        signup.activeCreateTab = feature
    }
}

struct OptionsView: View {
    @EnvironmentObject var af: AFState
    @EnvironmentObject var signup: SignupState
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: s0) {
                OptionRowView(rowLabel: "Color", rowOptions: skinColors, activeOption: af.skinColor)
                OptionRowView(rowLabel: "Freckles", rowOptions: skinFreckles, activeOption: af.freckles)
            }
            .opacity(signup.activeCreateTab == .skin ? 1 : 0)
            
            VStack(alignment: .leading, spacing: s0) {
                OptionRowView(rowLabel: "Color", rowOptions: hairColors, activeOption: af.hairColor)
                OptionRowView(rowLabel: "Style", rowOptions: hairStyles, activeOption: af.hairStyle)
            }
            .opacity(signup.activeCreateTab == .hair ? 1 : 0)
            
            VStack(alignment: .leading, spacing: s0) {
                OptionRowView(rowLabel: "Color", rowOptions: eyeColors, activeOption: af.eyeColor)
                OptionRowView(rowLabel: "Lashes", rowOptions: eyeLashes, activeOption: af.lashes)
            }
            .opacity(signup.activeCreateTab == .eyes ? 1 : 0)
        }
        .padding(.top, s4)
        .padding(.bottom, s24)
    }
}

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
    
    
    //FUNCTIONS
    
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

struct OptionView: View {
    @EnvironmentObject var af: AFState
    
    let name: String
    let optionType: OptionType
    let width = optionWidth
    var activeOption: Option
    
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
                .stroke(activeOption.name == name ? af.interface.userColor : setOptionElements().2, lineWidth: activeOption.name == name ? 2.5 : 2)
                .frame(width: activeOption.name == name ? width - 2.5 : width - 2, height: activeOption.name == name ? width - 2.5 : width - 2)
        )
        .frame(width: width, height: width)
        .animation(.linear(duration: 0.1), value: activeOption.name == name)
    }
    
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
}

struct EditorView_Previews: PreviewProvider {
    static var previews: some View {
        EditorView()
            .environmentObject(AFState())
            .environmentObject(SignupState())
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
    }
}
