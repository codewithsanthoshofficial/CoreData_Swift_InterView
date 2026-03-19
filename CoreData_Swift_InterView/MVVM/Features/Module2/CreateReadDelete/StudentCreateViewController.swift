//
//  StudentCreateViewController.swift
//  CoreData_Swift_InterView
//
//  Created by Koneti Santhosh Kumar on 18/03/26.
//

import UIKit

class StudentCreateViewController: UIViewController {
    
    @IBOutlet weak var studentNameTextField: UITextField!
    @IBOutlet weak var studentCourseTextField: UITextField!
    @IBOutlet weak var studentAgeTextField: UITextField!
    @IBOutlet weak var msgLbl: UILabel!
    @IBOutlet weak var tableview: UITableView!
    
    
    var viewmodel:StudentViewModel = StudentViewModel()
    var headerName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSearch()
        self.setup()
        self.bindViewModel()
    }
    override func viewWillAppear(_ animated: Bool) {
        viewmodel.loadStudents()
    }
    
    
    func resetFields() {
        self.studentNameTextField.text = ""
        self.studentCourseTextField.text = ""
        self.studentAgeTextField.text = ""
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StudentUpdateViewController" {
            if let destination = segue.destination as? StudentUpdateViewController, let indexpath = sender as? IndexPath {
                destination.viewModel = viewmodel
                destination.selectedItem = viewmodel.students[indexpath.row]
            }
        }
    }
    
    @IBAction func saveStudentDataAction(_ sender: UIButton) {
        
        let name = self.studentNameTextField.text ?? ""
        let course = self.studentCourseTextField.text ?? ""
        let age =  Int16(self.studentAgeTextField.text ?? "")
        
        if !viewmodel.validation(name: name, course: course, age: age ?? 0) {
            msgLbl.isHidden = false
            return
        } else {
            msgLbl.isHidden = true
        }
        
        viewmodel.addStudent( name: name, course: course,  age: age ?? 0)
        self.resetFields()
    }
}

extension StudentCreateViewController {
    func setup() {
        title = headerName
        view.backgroundColor = .white
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableview.dataSource = self
        tableview.delegate = self
    }
    
    private func bindViewModel() {
        viewmodel.onReload = { [weak self] in
            DispatchQueue.main.async {
                self?.tableview.reloadData()
            }
        }
    }
}

extension StudentCreateViewController:UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewmodel.students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let student = viewmodel.students[indexPath.row]
        
        cell.textLabel?.text = student.name
        cell.detailTextLabel?.text = "Dept: \(student.course ?? "") | Age: \(student.age)"
        
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewmodel.deleteStudent(index: indexPath.row)
        }
    }
}
    
extension StudentCreateViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "StudentUpdateViewController", sender: indexPath)
    }
}

extension StudentCreateViewController : UISearchBarDelegate {
    func setupSearch() {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            viewmodel.searchStudents(text: searchText)
    }
}
