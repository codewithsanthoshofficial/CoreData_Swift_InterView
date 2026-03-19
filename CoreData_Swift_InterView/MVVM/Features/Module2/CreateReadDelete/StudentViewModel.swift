//
//  StudentViewModel.swift
//  CoreData_Swift_InterView
//
//  Created by Koneti Santhosh Kumar on 18/03/26.
//

import Foundation


class StudentViewModel:NSObject {
    
    
    private let repository = StudentRepository()
    private(set) var students:[Student] = [] {
        didSet {
            onReload?()
        }
    }
    
    var onReload:(()->Void)?
    

    
    func addStudent(name:String, course:String, age:Int16) {
        repository.addStudent(name: name, course: course, age: age)
        loadStudents()
    }
    
    
    func updateStudent(_ student: Student, name: String, course: String, age: Int16) {
        repository.updateStudent(student, name: name, course: course, age: age)
        loadStudents()
    }
    
    
    func loadStudents() {
        students = repository.fetchStudents()
    }
    
    func deleteStudent(index:Int) {
      let student = students[index]
        repository.deleteStudent(student)
        loadStudents()
    }
    
    
    func validation(name: String, course: String, age: Int16) -> Bool {
        return !name.isEmpty && !course.isEmpty && age > 0
    }
    
    
}


extension StudentViewModel {
    func searchStudents(text: String?) {
        if let text = text, text.isEmpty {
            loadStudents()
        } else {
            students = repository.fetchStudents(searchText: text)
        }
    }
}
