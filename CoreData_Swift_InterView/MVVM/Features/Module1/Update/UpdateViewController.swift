//
//  UpdateViewController.swift
//  CoreData_Swift_InterView
//
//  Created by Koneti Santhosh Kumar on 17/03/26.
//

import UIKit
import CoreData

class UpdateViewController: UIViewController {

    @IBOutlet weak var empIDTextField: UITextField!
    @IBOutlet weak var empNameTextField: UITextField!
    @IBOutlet weak var empEmailTextField: UITextField!
    @IBOutlet weak var empDepoTextField: UITextField!
    
    @IBOutlet weak var msgLbl: UILabel!
    let viewmodel:UpdateViewModel = UpdateViewModel()
    var empData = EmployData()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.empIDTextField.text = "\(empData.id)"
        self.empNameTextField.text = empData.name
        self.empEmailTextField.text = empData.email
        self.empDepoTextField.text = empData.dept
        
    }
    
    @IBAction func saveDataAction(_ sender: UIButton) {
        
        let id = Int64(self.empIDTextField.text ?? "0")
        let name = self.empNameTextField.text ?? ""
        let email = self.empEmailTextField.text ?? ""
        let dept =  self.empDepoTextField.text ?? ""
        
        if !viewmodel.validation(id: id ?? 0, name: name, email: email, department: dept) {
            msgLbl.isHidden = false
            return
        } else {
            msgLbl.isHidden = true
        }
        
        self.empData.id = id ?? 0
        self.empData.name = self.empNameTextField.text
        self.empData.email = self.empEmailTextField.text
        self.empData.dept = self.empDepoTextField.text
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        
        do {
            try context.save()
            print("Data Saved")
        } catch {
            print("Data not saved")
        }
        
        
       // viewmodel.updateEmpData(id: id ?? 0, name: name, email: email, department: dept)
    }
    

}
