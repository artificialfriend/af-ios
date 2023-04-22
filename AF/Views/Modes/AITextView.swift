//
//  AITextView.swift
//  AF
//
//  Created by Cam Crain on 2023-04-01.
//

import SwiftUI

struct AITextView: View {
    @EnvironmentObject var af: AFOO
    @EnvironmentObject var chat: ChatOO
    @State private var textArray: [String] = []
    @State private var title: String = ""
    @State private var paragraphs: [String] = []
    @State private var spinnerOpacity: Double = 1
    @State private var spinnerRotation: Angle = Angle(degrees: 0)
    @State private var mainOpacity: Double = 0
    @State private var isLoading: Bool = false
    @Binding var response: String
    
    var body: some View {
        ZStack {
            Image("SpinnerIcon")
                .opacity(spinnerOpacity)
                .foregroundColor(af.af.interface.softColor)
                .rotationEffect(spinnerRotation)
            
            VStack(spacing: 16) {
                Text(title)
                    .font(.l)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(spacing: 16) {
                    ForEach(paragraphs, id: \.self) { p in
                        Text(p)
                            .font(.p)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .opacity(mainOpacity)
            .foregroundColor(.afBlack)
        }
        .padding(.horizontal, s16)
        .onAppear {
            toggleLoading()
        }
        .onChange(of: response) { _ in
            if response != "" { loadIn() }
        }
        .onChange(of: chat.resetActiveReadingMode) { _ in
            if chat.resetActiveReadingMode == true { reset() }
        }
    }
    
    func reset() {
        response = ""
        textArray = []
        title = ""
        paragraphs = []
        spinnerOpacity = 1
        mainOpacity = 0
    }
    
    func parseResponse() {
        textArray = response.components(separatedBy: "\n")
        title = textArray[0]
        if title.hasPrefix("Title:") { title = String(title.dropFirst(7)) }
        textArray.remove(at: 0)
        textArray.removeAll{ $0 == "" }
        paragraphs = textArray
    }
    
    func toggleLoading() {
        if !isLoading {
            isLoading = true
            withAnimation(.loadingSpin) { spinnerRotation = Angle(degrees: 360) }
        } else {
            isLoading = false
            spinnerRotation = Angle(degrees: 0)
        }
    }
    
    func loadIn() {
        parseResponse()
        withAnimation(.linear1) { spinnerOpacity = 0 }
        
        Task { try await Task.sleep(nanoseconds: 300_000_000)
            toggleLoading()
            withAnimation(.linear2) { mainOpacity = 1 }
        }
    }
}
