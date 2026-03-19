//
//  CoreDataStack.swift
//  CoreData_Swift_InterView
//
//  Created by Koneti Santhosh Kumar on 18/03/26.
//

import CoreData


struct CoreDataStack {
    
    static let shared = CoreDataStack()
    
    let container:NSPersistentContainer
    
    private init() {
        container = NSPersistentContainer(name: "CoreData_Swift_InterView")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("CoreData failed: \(error)")
            }
        }
    }
    
    var context:NSManagedObjectContext {
        container.viewContext
    }
    
    func saveContext() {
        if context.hasChanges {
            try? context.save()
        }
    }
}
