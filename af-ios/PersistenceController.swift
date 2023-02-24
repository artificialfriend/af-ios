//
//  PersistenceController.swift
//  af-ios
//
//  Created by Cam Crain on 2023-02-22.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer
    
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)

        for _ in 0..<10 {
            let message = Message(context: controller.container.viewContext)
            message.sortID = 1000000000
            message.text = "Testing, testing"
            message.isUserMessage = true
            message.createdAt = Date.now
        }

        return controller
    }()
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "MessagesModel")

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func save() {
        let context = container.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
    }
}
