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
            DividerView()
            
            TabsView()
            
            DividerView()
            
            OptionsView()
            
            DividerView()
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
    @EnvironmentObject var afState: AFState
    @EnvironmentObject var signupState: SignupState
    let label: String
    let feature: Feature
    
    var body: some View {
        Button(action: {
            signupState.activeCreateTab = feature
            impactMedium.impactOccurred()
        }) {
            Text(label)
                .font(signupState.activeCreateTab == feature ? .h3 : .s)
                .foregroundColor(signupState.activeCreateTab == feature ? .afBlack : afState.interface.medColor)
                .frame(width: s80)
                .animation(.shortSpring, value: signupState.activeCreateTab == feature)
        }
        .buttonStyle(Plain())
    }
}

struct OptionsView: View {
    @EnvironmentObject var afState: AFState
    @EnvironmentObject var signupState: SignupState
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: s0) {
                OptionRowView(rowLabel: "Color", rowOptions: skinColors, activeOption: afState.skinColor)
                OptionRowView(rowLabel: "Freckles", rowOptions: skinFreckles, activeOption: afState.freckles)
            }
            .opacity(signupState.activeCreateTab == .skin ? 1 : 0)
            
            VStack(alignment: .leading, spacing: s0) {
                OptionRowView(rowLabel: "Color", rowOptions: hairColors, activeOption: afState.hairColor)
                OptionRowView(rowLabel: "Style", rowOptions: hairStyles, activeOption: afState.hairStyle)
            }
            .opacity(signupState.activeCreateTab == .hair ? 1 : 0)
            
            VStack(alignment: .leading, spacing: s0) {
                OptionRowView(rowLabel: "Color", rowOptions: eyeColors, activeOption: afState.eyeColor)
                OptionRowView(rowLabel: "Lashes", rowOptions: eyeLashes, activeOption: afState.lashes)
            }
            .opacity(signupState.activeCreateTab == .eyes ? 1 : 0)
        }
        .padding(.top, s4)
        .padding(.bottom, s24)
    }
}

struct OptionRowView: View {
    @EnvironmentObject var afState: AFState
    let rowLabel: String
    let rowOptions: [Option]
    var activeOption: Option
    
    func setActiveOption(optionType: OptionType, option: Option) {
        switch optionType {
            case .skinColor:
                afState.skinColor = option
                if afState.skinColor.name == "Green Skin" {
                    afState.interface = interfaces[0]
                } else if afState.skinColor.name == "Blue Skin" {
                    afState.interface = interfaces[1]
                } else if afState.skinColor.name == "Purple Skin" {
                    afState.interface = interfaces[2]
                } else if afState.skinColor.name == "Pink Skin" {
                    afState.interface = interfaces[3]
                }
            case .skinFreckles:
                afState.freckles = option
            case .hairColor:
                afState.hairColor = option
            case .hairStyle:
                afState.hairStyle = option
            case .eyeColor:
                afState.eyeColor = option
            case .eyeLashes:
                afState.lashes = option
        }
    }
    
    var body: some View {
        Text(rowLabel)
            .font(.s)
            .foregroundColor(.afBlack)
            .padding(.horizontal, s12)
            .padding(.top, s12)
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: s8) {
                ForEach(rowOptions, id: \.name) { option in
                    Button(action: {
                        setActiveOption(optionType: option.optionType, option: option)
                        impactMedium.impactOccurred()
                    }) {
                        OptionView(name: option.name, optionType: option.optionType, activeOption: activeOption)
                    }
                    .buttonStyle(Spring())
                }
            }
            .padding(.horizontal, s12)
            .padding(.vertical, 4)
        }
    }
}

struct OptionView: View {
    @EnvironmentObject var afState: AFState
    let name: String
    let optionType: OptionType
    let width = optionWidth
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
        
        return (afState.interface.afImage, afState.interface.afColor, afState.interface.lineColor)
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
        .cornerRadius(cr16)
        .overlay(
            RoundedRectangle(cornerRadius: cr16)
                .stroke(activeOption.name == name ? afState.interface.userColor : setOptionElements().2, lineWidth: activeOption.name == name ? 2.5 : 2)
                .frame(width: activeOption.name == name ? width - 2.5 : width - 2, height: activeOption.name == name ? width - 2.5 : width - 2)
        )
        .frame(width: width, height: width)
        .animation(.linear(duration: 0.1), value: activeOption.name == name)
    }
}

struct EditorViewPreviews: PreviewProvider {
    static var previews: some View {
        EditorView()
            .environmentObject(AFState())
            .environmentObject(SignupState())
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
    }
}
