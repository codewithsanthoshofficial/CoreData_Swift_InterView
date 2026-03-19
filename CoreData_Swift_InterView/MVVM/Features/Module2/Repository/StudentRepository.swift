//
//  StudentRepository.swift
//  CoreData_Swift_InterView
//
//  Created by Koneti Santhosh Kumar on 18/03/26.
//

import Foundation
import CoreData


final class StudentRepository {
    
    private var context = CoreDataStack.shared.context
    
    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
    }
    
    //create
    func addStudent(name:String, course:String, age:Int16) {
        let student = Student(context:context)
        
        student.id = UUID()
        student.name = name
        student.course = course
        student.age = age
        
        CoreDataStack.shared.saveContext()
    }
    
    //read
    func fetchStudents() -> [Student] {
        let request:NSFetchRequest<Student> = Student.fetchRequest()
        //return (try? context.fetch(request)) ?? []
        
        //predicate ordering
        request.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]
        return executeFetch(request)
    }
    
    
    //update
    func updateStudent(_ student:Student, name:String, course:String, age:Int16) {
        student.name = name
        student.course = course
        student.age = age
        CoreDataStack.shared.saveContext()
    }
    
    
    //delete
    func deleteStudent(_ student:Student) {
        context.delete(student)
        CoreDataStack.shared.saveContext()
    }
    
    
    
    private func executeFetch<T:NSManagedObject>(_ request: NSFetchRequest<T>) -> [T] {
        do {
            return try context.fetch(request)
        } catch {
            print("Fetch failed:", error)
            return []
        }
    }
}
