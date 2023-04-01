//
//  AIQuizAnswerView.swift
//  AF
//
//  Created by Cam Crain on 2023-03-30.
//

import SwiftUI

struct AIQuizAnswerView: View {
    @EnvironmentObject var af: AFOO
    @State private var bgColor: Color = .black
    @State private var borderColor: Color = .black
    @State private var textColor: Color = .black
    @State private var correctIndicatorIcon: Image = Image("SmallCheckIcon")
    @State private var correctIndicatorBGColor: Color = .afUserGreen
    @State private var correctIndicatorOpacity: Double = 0
    @Binding var questionIsAnswered: Bool
    @Binding var score: Int
    let answer: String
    let correctAnswer: String
    
    var body: some View {
        Button(action: { handleBtnTap() }) {
            HStack {
                Text(answer)
                    .font(.sixteen)
                    .opacity(0.9)
                
                Spacer(minLength: 0)
                
                ZStack {
                    Circle()
                        .foregroundColor(correctIndicatorBGColor)
                    correctIndicatorIcon
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 12, height: 12)
                }
                .frame(width: 24, height: 24)
                .opacity(correctIndicatorOpacity)
                
            }
            .padding(.leading, s16)
            .padding(.trailing, s8)
            .frame(maxWidth: .infinity)
            .frame(height: 48, alignment: .leading)
            .foregroundColor(textColor)
            .background(bgColor)
            .overlay(RoundedRectangle(cornerRadius: cr8).stroke(lineWidth: 2).foregroundColor(borderColor))
            .cornerRadius(cr8)
        }
        .buttonStyle(Spring())
        .onAppear {
            bgColor = af.af.interface.afColor2
            borderColor = af.af.interface.afColor2
            textColor = af.af.interface.darkColor
        }
        .onChange(of: questionIsAnswered) { _ in
            if !questionIsAnswered {
                bgColor = af.af.interface.afColor2
                borderColor = af.af.interface.afColor2
                textColor = af.af.interface.darkColor
                correctIndicatorBGColor = .afUserGreen
                correctIndicatorIcon = Image("SmallCheckIcon")
                correctIndicatorOpacity = 0
            } else {
                withAnimation(.linear2.delay(1)) {
                    if answer == correctAnswer {
                        bgColor = .afGreen2
                        borderColor = .afUserGreen
                        textColor = .afDarkGreen
                    }
                }
            }
        }
    }
    
    func handleBtnTap() {
        if answer == correctAnswer {
            bgColor = .afGreen2
            borderColor = .afUserGreen
            textColor = .afDarkGreen
            score += 1
        } else {
            bgColor = .afRed2
            borderColor = .afUserRed
            textColor = .afDarkRed
            correctIndicatorBGColor = .afUserRed
            correctIndicatorIcon = Image("SmallXIcon")
        }
        
        correctIndicatorOpacity = 1
        questionIsAnswered = true
    }
}
