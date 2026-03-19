//
//  AddEmployViewController.swift
//  CoreData_Swift_InterView
//
//  Created by Koneti Santhosh Kumar on 17/03/26.
//

import UIKit

class AddEmployViewController: UIViewController {

    
    @IBOutlet weak var empIDTextField: UITextField!
    @IBOutlet weak var empNameTextField: UITextField!
    @IBOutlet weak var empEmailTextField: UITextField!
    @IBOutlet weak var empDepoTextField: UITextField!
    
    @IBOutlet weak var msgLbl: UILabel!
    let viewmodel:AddEmpViewModel = AddEmpViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        viewmodel.saveEmpData(id: id ?? 0, name: name, email: email, department: dept)
    }
    
    
    @IBAction func empListBtnAction(_ sender: UIButton) {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FetchEmpViewController") as! FetchEmpViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StudentCreateViewController" {
            if let destination = segue.destination as? StudentCreateViewController {
                destination.modalPresentationStyle = .fullScreen
                destination.headerName = "Students List"
            }
        }
    }
}
