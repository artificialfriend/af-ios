//
//  ChatView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-01-24.
//

import SwiftUI

struct ChatView: View {
    @FetchRequest(sortDescriptors: [SortDescriptor(\.msgID)]) var msgs: FetchedResults<Message>
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var global: GlobalOO
    @EnvironmentObject var af: AFOO
    @EnvironmentObject var chat: ChatOO
    
    
    var body: some View {
        ZStack {
//            VStack {
//                ForEach(msgs) { msg in
//                    if msg.isUserMsg && msg.isNew {
//                        UserMsgView(text: msg.text!, isNew: false)
//                            .fixedSize(horizontal: false, vertical: true)
//                            .background {
//                                GeometryReader { geo in
//                                    Color.clear
//                                        .onAppear {
//                                            chat.currentMsgHeight = geo.size.height
//                                            print(chat.currentMsgHeight)
//                                        }
//                                }
//                            }
//                    }
////                    } else {
////                        AFMsgView(msgID: msg.msgID, text: msg.text!, isNew: false)
////                            .fixedSize(horizontal: false, vertical: true)
////                    }
//                }
//            }
            
            GeometryReader { geo in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: s0) {
                        ForEach(chat.uniqueMsgDates, id: \.self) { date in
                            MsgsDateLabelView(date: date)
                                .padding(.bottom, s8)
                                .padding(.top, s32)
                            
                            VStack {
                                ForEach(chat.dateMsgGroups[date]!) { msg in
                                    if msg.isUserMsg {
                                        UserMsgView(text: msg.text!, isNew: msg.isNew)
                                            .fixedSize(horizontal: false, vertical: true)
                                    } else {
                                        AFMsgView(msgID: msg.msgID, text: msg.text!, isNew: msg.isNew)
                                            .fixedSize(horizontal: false, vertical: true)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.top, s240)
                    .padding(.bottom, global.keyboardIsPresent ? chat.msgsBottomPadding + s8 : chat.msgsBottomPadding)
                    .rotationEffect(Angle(degrees: 180))
                }
                .rotationEffect(Angle(degrees: 180))
                .scrollDismissesKeyboard(.interactively)
                .animation(.shortSpringF, value: chat.msgsBottomPadding)
            }
            .background(Color.white)
            
            
        }
        .ignoresSafeArea(edges: .vertical)
        .onAppear {
            if msgs.count > 0 { chat.currentMsgID = msgs[msgs.count - 1].msgID + 1 }
            chat.uniqueMsgDates = createDateMsgGroups().0
            chat.dateMsgGroups = createDateMsgGroups().1
        }
    }
    
    @ViewBuilder func createMsgsView() -> some View {
        //TODO: Figure out why this is getting called so many times
        let dateMsgGroups = createDateMsgGroups()
        MsgsView(uniqueDates: dateMsgGroups.0, dateMsgGroups: dateMsgGroups.1)
    }
    
    
    
    func createDateMsgGroups() -> ([String], [String: [Message]]) {
        print("hit")
        let uniqueDates = findUniqueDates()
        var dateMsgGroups: [String: [Message]] = [:]
        
        for date in uniqueDates {
            var msgsFromDate: [Message] = []
            
            for msg in msgs {
                let msgDate = chat.formatDate(msg.createdAt!)
                
                if msgDate == date {
                    msgsFromDate.append(msg)
                }
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
                
                if msgDate == date {
                    isNew = false
                }
                
                if isNew && uniqueDates.firstIndex(of: date) == uniqueDates.count - 1 {
                    uniqueDates.append(msgDate)
                }
            }
        }
        
        return uniqueDates
    }
    
    func addDummyMsgs() {
        addMsg(
            text: "What is Einstein famous for?",
            isUserMsg: true,
            isNew: false,
            createdAt: "2023-01-14T12:30:11.000000"
        )
        
        addMsg(
            text: "Einstein is famous for his theory of relativity, which revolutionized modern physics and is considered one of the most important scientific discoveries of the 20th century. He also developed the equation E=mc2, which describes the relationship between mass and energy.",
            isUserMsg: false,
            isNew: false,
            createdAt: "2023-01-14T12:30:11.000000"
        )
        
        addMsg(
            text: "What does mitochondria do?",
            isUserMsg: true,
            isNew: false,
            createdAt: "2023-02-27T08:02:33.000000"
        )
        
        addMsg(
            text: "Mitochondria are the powerhouses of the cell, responsible for converting energy from food into a form that cells can use. They are found in the cytoplasm of all eukaryotic cells and are essential for the production of energy in the form of ATP. Mitochondria also play a role in other cellular processes, such as metabolism, cell signaling, and apoptosis.",
            isUserMsg: false,
            isNew: false,
            createdAt: "2023-02-27T08:02:33.000000"
        )
        
        addMsg(
            text: "Write a rhyming love poem for a girl named anna",
            isUserMsg: true,
            isNew: false,
            createdAt: "2023-02-27T14:55:01.000000"
        )
        
        addMsg(
            text: "Anna, my love, I'd like to say,\nYour beauty is here to stay.\nYour eyes, your lips, your hair,\nYour beauty is beyond compare.",
            isUserMsg: false,
            isNew: false,
            createdAt: "2023-02-27T14:55:01.000000"
        )
        
        addMsg(
            text: "Who founded microsoft?",
            isUserMsg: true,
            isNew: false,
            createdAt: "2023-02-28T20:09:33.000000"
        )
        
        addMsg(
            text: "Microsoft was founded by Bill Gates and Paul Allen in 1975.",
            isUserMsg: false,
            isNew: false,
            createdAt: "2023-02-28T20:09:33.000000"
        )
        
        PersistenceController.shared.save()
        
        func addMsg(text: String, isUserMsg: Bool, isNew: Bool, createdAt: String) {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
            formatter.timeZone = TimeZone(identifier: "UTC")
            let date = formatter.date(from: createdAt)
            
            let msg = Message(context: managedObjectContext)
            msg.msgID = chat.currentMsgID
            msg.text = text
            msg.isUserMsg = isUserMsg
            msg.isNew = false
            msg.createdAt = date
            chat.currentMsgID += 1
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AFOO())
            .environmentObject(ChatOO())
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
    }
}
