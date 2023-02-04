//
//  MessageToolbarView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-02-04.
//

import SwiftUI

struct MessageToolbarView: View {
    @EnvironmentObject var af: AFState
    @EnvironmentObject var chat: ChatState
    
    var text: Binding<String>
    var prompt: String
    @State private var optionsOpen: Bool = false
    @State private var optionsOpacity: Double = 0
    @State private var optionsOffset: CGFloat = 112
    @State private var moreColor: Color = Color.black
    @State private var copyColor: Color = Color.black
    @State private var copyOpacity: Double = 1
    @State private var copyRotation: Angle = Angle(degrees: 0)
    @State private var retryColor: Color = Color.black
    @State private var retryRotation: Angle = Angle(degrees: 0)
    
    var body: some View {
        HStack(spacing: s16) {
            HStack(spacing: s16) {
                Button(action: { handleMoreTap() }) {
                    Image("MoreIcon")
                        .resizable()
                        .onAppear { moreColor = af.interface.medColor }
                        .foregroundColor(moreColor)
                        .frame(width: 22, height: 22)
                }
                .buttonStyle(Spring())
                
                DividerView(direction: .vertical)
                    .opacity(optionsOpacity)
                
                Image("AdjustIcon")
                    .resizable()
                    .frame(width: 22, height: 22)
                    .opacity(optionsOpacity)
                
                DividerView(direction: .vertical)
                    .opacity(optionsOpacity)
                
                Button(action: { handleRetryTap(prompt: prompt) }) {
                    Image("RetryIcon")
                        .resizable()
                        .onAppear { retryColor = af.interface.medColor }
                        .rotationEffect(retryRotation)
                        .foregroundColor(retryColor)
                        .frame(width: 22, height: 22)
                        .opacity(optionsOpacity)
                }
                .buttonStyle(Spring())
            }
            .offset(x: optionsOffset)
            
            DividerView(direction: .vertical)
            
            Button(action: { handleCopyTap(text: text) }) {
                ZStack {
                    Image("CheckIcon")
                        .resizable()
                        .rotationEffect(Angle(degrees: 270))
                        .opacity(1 - copyOpacity)
                    
                    Image("CopyIcon")
                        .resizable()
                        .opacity(copyOpacity)
                }
                .onAppear { copyColor = af.interface.medColor }
                .foregroundColor(copyColor)
                .rotationEffect(copyRotation)
                .frame(width: 22, height: 22)
            }
            .buttonStyle(Spring())
        }
        .foregroundColor(af.interface.medColor)
        .frame(height: 22)
    }
    
    
    //FUNCTIONS
    
    func handleRetryTap(prompt: String) {
        impactMedium.impactOccurred()
        
        withAnimation(.linear1) {
            retryColor = af.interface.userColor
        }
        
        withAnimation(.shortSpringD) {
            retryRotation = Angle(degrees: 180)
        }
        
        Task { try await Task.sleep(nanoseconds: 1_000_000_000)
            withAnimation(.linear1) {
                retryColor = af.interface.medColor
            }
            
            retryRotation = Angle(degrees: 0)
        }
    }
    
    func handleCopyTap(text: Binding<String>) {
        impactMedium.impactOccurred()
        
        let pasteboard = UIPasteboard.general
        pasteboard.string = text.wrappedValue
        
        withAnimation(.linear1) {
            copyColor = af.interface.userColor
            copyOpacity = 0
        }
        
        withAnimation(.shortSpringD) {
            copyRotation = Angle(degrees: 90)
        }
        
        Task { try await Task.sleep(nanoseconds: 1_000_000_000)
            withAnimation(.linear1) {
                copyColor = af.interface.medColor
                copyOpacity = 1
            }
            
            withAnimation(.shortSpringD) {
                copyRotation = Angle(degrees: 0)
            }
        }
    }
    
    func handleMoreTap() {
        impactMedium.impactOccurred()
        
        if optionsOpen {
            withAnimation(.linear1) {
                optionsOpacity = 0
                moreColor = af.interface.medColor
            }
            
            Task { try await Task.sleep(nanoseconds: 75_000_000)
                withAnimation(.shortSpringC) {
                    optionsOffset = 112
                }
                
                optionsOpen = false
            }
            
            
        } else {
            withAnimation(.shortSpringC) {
                optionsOffset = 0
                moreColor = af.interface.userColor
            }
            
            Task { try await Task.sleep(nanoseconds: 75_000_000)
                withAnimation(.linear2) {
                    optionsOpacity = 1
                }
                
                optionsOpen = true
            }
        }
        
    }
}

//struct MessageToolbarView_Previews: PreviewProvider {
//    @State var previewText: String = "Message text"
//    
//    static var previews: some View {
//        MessageToolbarView(text: $previewText, prompt: "")
//            .environmentObject(AFState())
//            .environmentObject(ChatState())
//    }
//}
