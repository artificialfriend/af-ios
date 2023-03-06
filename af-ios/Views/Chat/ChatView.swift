//
//  ChatView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-01-24.
//

import SwiftUI

struct ChatView: View {
    @FetchRequest(sortDescriptors: [SortDescriptor(\.sortID)]) var messages: FetchedResults<Message>
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var global: GlobalOO
    @EnvironmentObject var af: AFOO
    @EnvironmentObject var chat: ChatOO
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: s0) {
                        createMessagesView()
                    }
                    .padding(.top, s240)
                    .padding(.bottom, global.keyboardIsPresent ? chat.messagesBottomPadding + s8 : chat.messagesBottomPadding)
                    .rotationEffect(Angle(degrees: 180))
                }
                .rotationEffect(Angle(degrees: 180))
                .scrollDismissesKeyboard(.interactively)
                .animation(.shortSpringC, value: chat.messagesBottomPadding)
            }
            .ignoresSafeArea(edges: .vertical)
        }
        .onAppear {
            chat.currentSortID = Int32(messages.count - 1)
            //if messages.count == 0 { addDummyMessages() }
        }
    }
    
    @ViewBuilder func createMessagesView() -> some View {
        //TODO: Figure out why this is getting called so many times
        let dateMessageGroups = createDateMessageGroups()
        MessagesView(uniqueDates: dateMessageGroups.0, dateMessageGroups: dateMessageGroups.1)
    }
    
    func createDateMessageGroups() -> ([String], [String: [Message]]) {
        let uniqueDates = findUniqueDates()
        var dateMessageGroups: [String: [Message]] = [:]
        
        for date in uniqueDates {
            var messagesFromDate: [Message] = []
            
            for message in messages {
                let messageDate = chat.formatDate(message.createdAt!)
                
                if messageDate == date {
                    messagesFromDate.append(message)
                }
            }
            
            dateMessageGroups[date] = messagesFromDate
        }
        
        return (uniqueDates, dateMessageGroups)
    }
    
    func findUniqueDates() -> [String] {
        var uniqueDates: [String] = []
        
        if messages.count != 0 {
            let firstDate = chat.formatDate(messages[0].createdAt!)
            uniqueDates.append(firstDate)
        }
        
        for message in messages {
            let messageDate = chat.formatDate(message.createdAt!)
            
            for date in uniqueDates {
                var isNew = true
                
                if messageDate == date {
                    isNew = false
                }
                
                if isNew && uniqueDates.firstIndex(of: date) == uniqueDates.count - 1 {
                    uniqueDates.append(messageDate)
                }
            }
        }
        
        return uniqueDates
    }
    
    func addDummyMessages() {
        addMessage(
            text: "What is Einstein famous for?",
            isUserMessage: true,
            isNew: false,
            createdAt: "2023-01-14T12:30:11.000000"
        )
        
        addMessage(
            text: "Einstein is famous for his theory of relativity, which revolutionized modern physics and is considered one of the most important scientific discoveries of the 20th century. He also developed the equation E=mc2, which describes the relationship between mass and energy.",
            isUserMessage: false,
            isNew: false,
            createdAt: "2023-01-14T12:30:11.000000"
        )
        
        addMessage(
            text: "What does mitochondria do?",
            isUserMessage: true,
            isNew: false,
            createdAt: "2023-02-27T08:02:33.000000"
        )
        
        addMessage(
            text: "Mitochondria are the powerhouses of the cell, responsible for converting energy from food into a form that cells can use. They are found in the cytoplasm of all eukaryotic cells and are essential for the production of energy in the form of ATP. Mitochondria also play a role in other cellular processes, such as metabolism, cell signaling, and apoptosis.",
            isUserMessage: false,
            isNew: false,
            createdAt: "2023-02-27T08:02:33.000000"
        )
        
        addMessage(
            text: "Write a rhyming love poem for a girl named anna",
            isUserMessage: true,
            isNew: false,
            createdAt: "2023-02-27T14:55:01.000000"
        )
        
        addMessage(
            text: "Anna, my love, I'd like to say,\nYour beauty is here to stay.\nYour eyes, your lips, your hair,\nYour beauty is beyond compare.",
            isUserMessage: false,
            isNew: false,
            createdAt: "2023-02-27T14:55:01.000000"
        )
        
        addMessage(
            text: "Who founded microsoft?",
            isUserMessage: true,
            isNew: false,
            createdAt: "2023-02-28T20:09:33.000000"
        )
        
        addMessage(
            text: "Microsoft was founded by Bill Gates and Paul Allen in 1975.",
            isUserMessage: false,
            isNew: false,
            createdAt: "2023-02-28T20:09:33.000000"
        )
        
        PersistenceController.shared.save()
        
        func addMessage(text: String, isUserMessage: Bool, isNew: Bool, createdAt: String) {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
            formatter.timeZone = TimeZone(identifier: "UTC")
            let date = formatter.date(from: createdAt)
            
            let message = Message(context: managedObjectContext)
            message.sortID = chat.currentSortID
            message.text = text
            message.isUserMessage = isUserMessage
            message.isNew = false
            message.createdAt = date
            chat.currentSortID += 1
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
