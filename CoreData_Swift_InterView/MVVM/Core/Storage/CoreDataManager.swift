//
//  CoreDataManager.swift
//  CoreData_Swift_InterView
//
//  Created by Koneti Santhosh Kumar on 18/03/26.
//


/*
import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    let persistentContainer: NSPersistentContainer
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "CoreData_Swift_InterView")
        
        let description = NSPersistentStoreDescription()
        description.setOption(true as NSNumber, forKey: NSMigratePersistentStoresAutomaticallyOption)
        description.setOption(true as NSNumber, forKey: NSInferMappingModelAutomaticallyOption)
        persistentContainer.persistentStoreDescriptions = [description]
        
        persistentContainer.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Core Data failed: \(error)")
            }
        }
    }
    
    // MARK: - CRUD Operations
    
    func addEmployee(name: String, email: String, department: String) {
        let employee = Employee(context: context)
        employee.id = "\(UUID().hashValue)"
        employee.name = name
        employee.email = email
        employee.department = department
        
        save()
    }
    
    func fetchEmployees(department: String? = nil) -> [Employee] {
        let request: NSFetchRequest<Employee> = Employee.fetchRequest()
        
        if let department = department {
            request.predicate = NSPredicate(format: "department == %@", department)
        }
        
        request.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]
        
        return (try? context.fetch(request)) ?? []
    }
    
    func updateEmployee(_ employee: Employee, name: String, email: String) {
        employee.name = name
        employee.email = email
        save()
    }
    
    func deleteEmployee(_ employee: Employee) {
        context.delete(employee)
        save()
    }
    
    func deleteAll() {
        let request: NSFetchRequest<NSFetchRequestResult> = Employee.fetchRequest()
        let batchDelete = NSBatchDeleteRequest(fetchRequest: request)
        
        try? context.execute(batchDelete)
    }
    
    private func save() {
        do {
            try context.save()
            print("Saved Data")
        } catch {
            print("Save failed: \(error)")
        }
    }
}
*/
