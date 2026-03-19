//
//  StudentUpdateViewController.swift
//  CoreData_Swift_InterView
//
//  Created by Koneti Santhosh Kumar on 19/03/26.
//

import UIKit
import CoreData

class StudentUpdateViewController: UIViewController {

    @IBOutlet weak var studentName:UITextField!
    @IBOutlet weak var studnetCourse:UITextField!
    @IBOutlet weak var studentAge:UITextField!
    
    var selectedItem = Student()
    var viewModel: StudentViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupData()
    }

    func setupData() {
        studentName.text = selectedItem.name
        studnetCourse.text = selectedItem.course
        studentAge.text = "\(selectedItem.age)"
    }

    @IBAction func updateStudentData(_ sender: UIButton) {
        let name = studentName.text ?? ""
        let course = studnetCourse.text ?? ""        
        guard let age = Int16(studentAge.text ?? "") else { return }
        viewModel.updateStudent(selectedItem, name: name, course: course, age: age)
        dismiss(animated: true)
    }
}
