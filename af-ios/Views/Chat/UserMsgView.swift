//
//  UserMsgView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-01-26.
//

import SwiftUI

struct UserMsgView: View {
    //@FetchRequest(sortDescriptors: [SortDescriptor(\.msgID)]) var msgs: FetchedResults<Message>
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var af: AFOO
    @EnvironmentObject var chat: ChatOO
    @State private var isLoaded: Bool = true
    @State private var opacity: Double = 0
    @State private var msgHeight: CGFloat = 0
    let text: String
    let isNew: Bool
    
    var body: some View {
        if isLoaded {
            HStack(spacing: s0) {
                Spacer()
                
                Text(text)
                    .font(.p)
                    .foregroundColor(.white)
                    .padding(.horizontal, s16)
                    .padding(.vertical, s12)
                    .frame(alignment: .trailing)
                    .background(af.af.interface.userColor)
                    .cornerRadius(s24, corners: .topRight)
                    .cornerRadius(s24, corners: .topLeft)
                    .cornerRadius(s8, corners: .bottomRight)
                    .cornerRadius(s24, corners: .bottomLeft)
                    .padding(.leading, s64)
                    .padding(.trailing, s12)
            }
            .opacity(isNew ? opacity : 1)
            .background {
                GeometryReader { geo in
                    Color.clear
                        .onAppear {
                            if isNew {
                                msgHeight = geo.size.height + s8
                                chat.msgsBottomPadding -= msgHeight
                            }
                        }
                }
            }
            .onAppear {
                if isNew {
                    Task { try await Task.sleep(nanoseconds: 1_000_000_000)
                        loadIn()
                    }
                }
            }
        }
    }
    
    func loadIn() {
        isLoaded = true
        
        withAnimation(.longSpring) {//.shortSpringA) {
            chat.msgsBottomPadding += msgHeight
        }

        withAnimation(.linear1) {
            opacity = 1
        }
        
        Task { try await Task.sleep(nanoseconds: 2_000_000_000)//100_000_000)
            chat.addMsg(text: "", isUserMsg: false, managedObjectContext: managedObjectContext)
        }
    }
}

//struct UserMsg_Previews: PreviewProvider {
//    static var previews: some View {
//        UserMsgView(id: "Summarize chapter 2", text: "Summarize chapter 2")
//            .environmentObject(AFOO())
//            .environmentObject(ChatOO())
//            .environmentObject(MsgsState())
//            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
//    }
//}
