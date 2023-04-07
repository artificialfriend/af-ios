//
//  AddBlockBtnView.swift
//  AF
//
//  Created by Cam Crain on 2023-04-04.
//

import SwiftUI

struct AddBlockBtnView: View {
    @EnvironmentObject var af: AFOO
    @Binding var state: AddBlockBtnState
    @Binding var questionIsPresent: Bool
    @Binding var questionOpacity: Double
    @Binding var questionScale: CGFloat
    @Binding var aiTextIsPresent: Bool
    @Binding var aiTextOpacity: Double
    @Binding var aiTextScale: CGFloat
    @Binding var aiQuizIsPresent: Bool
    @Binding var aiQuizOpacity: Double
    @Binding var aiQuizScale: CGFloat
    @Binding var saveBtnIsPresent: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: { toggleState() }) {
                HStack {
                    Spacer()
                    
                    Image("PlusIcon")
                        .resizable()
                        .frame(width: 22, height: 22)
                        .foregroundColor(state.setPlusIconColor(af: af))
                        .animation(.linear1, value: state)
                        .padding(.vertical, 13)
                    
                    Spacer()
                }
                .background(af.af.interface.afColor)
            }
            .buttonStyle(Spring())
            
            VStack(spacing: 4) {
                AddBlockInnerBtnView(
                    addBlockBtnState: $state,
                    presenceToControl: $aiTextIsPresent,
                    opacityToControl: $aiTextOpacity,
                    scaleToControl: $aiTextScale,
                    saveBtnIsPresent: $saveBtnIsPresent,
                    blockType: .aiText
                )
                
                AddBlockInnerBtnView(
                    addBlockBtnState: $state,
                    presenceToControl: $aiQuizIsPresent,
                    opacityToControl: $aiQuizOpacity,
                    scaleToControl: $aiQuizScale,
                    saveBtnIsPresent: $saveBtnIsPresent,
                    blockType: .aiQuiz
                )
                
                AddBlockInnerBtnView(
                    addBlockBtnState: $state,
                    presenceToControl: $questionIsPresent,
                    opacityToControl: $questionOpacity,
                    scaleToControl: $questionScale,
                    saveBtnIsPresent: $saveBtnIsPresent,
                    blockType: .question
                )
            }
            .opacity(state.blockTypesOpacity)
            .offset(y: state.blockTypesOffset)
            .padding(.horizontal, s8)
            .padding(.bottom, s8)
        }
        .frame(height: state.height, alignment: .top)
        .animation(.shortSpringB, value: state)
        .frame(maxWidth: .infinity)
        .background(af.af.interface.afColor)
        .cornerRadius(s24)
    }
    
    func toggleState() {
        impactMedium.impactOccurred()
        dismissKeyboard()
        
        if state == .closed {
            withAnimation(.shortSpringB) { state = .open }
        }
        else {
            withAnimation(.shortSpringB) { state = .closed }
        }
    }
}

enum AddBlockBtnState {
    case closed
    case open
    
    var height: CGFloat {
        switch self {
        case .closed: return 48
        case .open: return 184
        }
    }
    
    var blockTypesOpacity: Double {
        switch self {
        case .closed: return 0
        case .open: return 1
        }
    }
    
    var blockTypesOffset: CGFloat {
        switch self {
        case .closed: return -24
        case .open: return 0
        }
    }
    
    func setPlusIconColor(af: AFOO) -> Color {
        switch self {
        case .closed: return af.af.interface.medColor
        case .open: return af.af.interface.userColor
        }
    }
}
