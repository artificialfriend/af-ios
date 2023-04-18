//
//  ChatView.swift
//  AF
//
//  Created by Cam Crain on 2023-01-24.
//

import SwiftUI

struct ChatView: View {
    @FetchRequest(sortDescriptors: [SortDescriptor(\.msgID)]) var msgs: FetchedResults<Message>
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var global: GlobalOO
    @EnvironmentObject var user: UserOO
    @EnvironmentObject var af: AFOO
    @EnvironmentObject var chat: ChatOO
    @State private var animation: Animation = .linear0
    @State private var currentDateOpacity: Double = 0
    @State private var currentDateIsPresent: Bool = false
    
    var body: some View {
        ZStack {
            //DUMMY MESSAGES, FOR FINDING HEIGHT OF NEW USER MESSAGES
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    ForEach(chat.dummyMsgs, id: \.self) { msg in
                        UserMsgView(text: msg.text!, isNew: false)
                        .background {
                            GeometryReader { geo in
                                Color.clear
                                    .onAppear {
                                        chat.currentUserMsgHeight = geo.size.height
                                    }
                            }
                        }
                    }
                }
            }
            
            GeometryReader { geo in
                ScrollViewReader { scrollView in
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack(spacing: s0) {
                            ForEach(chat.uniqueMsgDates, id: \.self) { date in
                                if date == chat.uniqueMsgDates.last && chat.dateMsgGroups[date]!.count == 1 && currentDateIsPresent {
                                    MsgsDateLabelView(date: date)
                                        .padding(.bottom, s8)
                                        .padding(.top, s32)
                                        .opacity(date == chat.uniqueMsgDates.last ? currentDateOpacity : 0)
                                } else {
                                    MsgsDateLabelView(date: date)
                                        .padding(.bottom, s8)
                                        .padding(.top, s32)
                                }
                                
                                VStack() {
                                    ForEach(chat.dateMsgGroups[date]!) { msg in
                                        if msg.isUserMsg {
                                            UserMsgView(
                                                text: msg.text!,
                                                isNew: msg.isNew
                                            )
                                            .id(msg.msgID)
                                            .fixedSize(horizontal: false, vertical: true)
                                            .onAppear {
                                                if chat.dateMsgGroups[date]!.count == 1 {
                                                    Task { try await Task.sleep(nanoseconds: 20_000_000)
                                                        currentDateIsPresent = true
                                                        withAnimation(.linear1) {
                                                            currentDateOpacity = 1
                                                        }
                                                    }
                                                    
                                                    Task { try await Task.sleep(nanoseconds: 30_000_000_000)
                                                        currentDateOpacity = 0
                                                    }
                                                }
                                            }
                                        } else {
                                            AFMsgView(
                                                id: msg.msgID,
                                                text: msg.text!,
                                                length: AdjustOption.fromString(msg.length!)!,
                                                tone: AdjustOption.fromString(msg.tone!)!,
                                                inErrorState: msg.inErrorState,
                                                isNew: msg.isNew,
                                                isPremade: msg.isPremade,
                                                hasToolbar: msg.hasToolbar
                                            )
                                            .id(msg.msgID)
                                            .fixedSize(horizontal: false, vertical: true)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.top, s240)
                        .id("MsgHistory")
                        .onChange(of: msgs.last?.text) { _ in
                            if !msgs.last!.isUserMsg && msgs.last!.text != "" {
                                Task { try await Task.sleep(nanoseconds: 400_000_000)
                                    let dateIndex = chat.uniqueMsgDates.count - 1
                                    let date = chat.uniqueMsgDates[dateIndex]
                                    let msgIndex = chat.dateMsgGroups[date]!.count - 1
                                    let msgID = chat.dateMsgGroups[date]![msgIndex].msgID

                                    withAnimation {
                                        scrollView.scrollTo(msgID - 1, anchor: .bottom)
                                    }
                                }
                            }
                        }
                        .onChange(of: chat.composerInput.isEmpty) { _ in
                            withAnimation {
                                scrollView.scrollTo("MsgHistory", anchor: .top)
                            }
                        }
                        .onChange(of: global.keyboardIsPresent) { _ in
                            if global.keyboardIsPresent {
                                withAnimation {
                                    scrollView.scrollTo("MsgHistory", anchor: .top)
                                }
                            }
                        }
                        .rotationEffect(Angle(degrees: 180))
                    }
                    .rotationEffect(Angle(degrees: 180))
                    //.scrollDismissesKeyboard(.immediately)
                    .animation(animation, value: chat.msgsBottomPadding)
                }
                .padding(.top, global.topNavHeight + s8)
                .padding(.bottom, global.keyboardIsPresent ? chat.msgsBottomPadding - s24 : chat.msgsBottomPadding)
            }
            .background(Color.white)
        }
        .ignoresSafeArea(edges: .vertical)
        .onAppear {
            if msgs.count > 0 { chat.currentMsgID = msgs[msgs.count - 1].msgID + 1 }
            chat.uniqueMsgDates = createDateMsgGroups().0
            chat.dateMsgGroups = createDateMsgGroups().1
            
            Task { try await Task.sleep(nanoseconds: 100_000_000)
                animation = .shortSpringD
            }
        }
        .onTapGesture {
            if chat.menuIsOpen { chat.closeMenu = true }
            else { dismissKeyboard() }
        }
    }
    
    func createDateMsgGroups() -> ([String], [String: [Message]]) {
        let uniqueDates = findUniqueDates()
        var dateMsgGroups: [String: [Message]] = [:]
        
        for date in uniqueDates {
            var msgsFromDate: [Message] = []
            
            for msg in msgs {
                let msgDate = chat.formatDate(msg.createdAt!)
                if msgDate == date { msgsFromDate.append(msg) }
            }
            
            dateMsgGroups[date] = msgsFromDate
        }
        
        return (uniqueDates, dateMsgGroups)
    }
    
    func findUniqueDates() -> [String] {
        var uniqueDates: [String] = []
        
        if msgs.count != 0 {
            let firstDate = chat.formatDate(msgs[0].createdAt!)
            uniqueDates.append(firstDate)
        }
        
        for msg in msgs {
            let msgDate = chat.formatDate(msg.createdAt!)
            
            for date in uniqueDates {
                var isNew = true
                if msgDate == date { isNew = false }
                
                if isNew && uniqueDates.firstIndex(of: date) == uniqueDates.count - 1 {
                    uniqueDates.append(msgDate)
                }
            }
        }
        
        return uniqueDates
    }
}
