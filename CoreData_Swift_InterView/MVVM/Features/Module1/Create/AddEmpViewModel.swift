//
//  AddEmpViewModel.swift
//  CoreData_Swift_InterView
//
//  Created by Koneti Santhosh Kumar on 17/03/26.
//

import UIKit
import Foundation
import CoreData




class AddEmpViewModel: NSObject {
    
    
    
    func validation(id: Int64, name: String, email: String, department: String) -> Bool {
        
        if id == 0 && name.isEmpty && email.isEmpty && department.isEmpty {
          return false
        }
        return true
    }
    
    
    func saveEmpData(id: Int64, name: String, email: String, department: String) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let empData:EmployData = NSEntityDescription.insertNewObject(forEntityName: "EmployData", into: context) as! EmployData
        
        empData.id = id
        empData.name = name
        empData.email = email
        empData.dept = department
        
        do {
            try context.save()
            print("Data Saved")
        } catch {
            print("Data not saved")
        }
    }
      
}




