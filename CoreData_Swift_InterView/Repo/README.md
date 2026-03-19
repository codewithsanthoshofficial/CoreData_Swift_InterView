# CoreDataSwift - Complete Core Data POC & Interview Guide

Complete end-to-end Core Data implementation in Swift with sample POC and comprehensive interview preparation guide.

## 📚 Contents

- **Core Data Fundamentals** - Stack, components, best practices
- **Complete CRUD Examples** - Create, Read, Update, Delete operations
- **Interview Q&A** - 10+ detailed answers with code examples
- **Sample Project** - Ready-to-use Employee Management app
- **Advanced Topics** - Migration, Concurrency, Relationships

## 🚀 Quick Start

### 1. Core Data Stack Setup
```swift
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    let persistentContainer: NSPersistentContainer

    private init() {
        persistentContainer = NSPersistentContainer(name: "SampleModel")
        persistentContainer.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Core Data load failed: \(error)")
            }
        }
    }
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
}