//
//  FetchEmpViewController.swift
//  CoreData_Swift_InterView
//
//  Created by Koneti Santhosh Kumar on 17/03/26.
//

import UIKit
import CoreData

class FetchEmpViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
    var empList : [EmployData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.dataSource = self
        self.tableview.delegate = self
        
        self.fetchEmpData()
        DispatchQueue.main.async {
            //reload tableview
            self.tableview.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableview.reloadData()
    }
    
    
    func fetchEmpData() {
        
        let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "EmployData")
        
        do {
            let list = try context?.fetch(fetchRequest)
            self.empList = list as! [EmployData]
        }
        catch {
            print(error)
        }
    }

}

extension FetchEmpViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.empList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil
        {
            cell = UITableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        }
        cell?.selectionStyle = .none
        var config = cell?.defaultContentConfiguration()
        config?.text = self.empList[indexPath.row].name
        config?.textProperties.font = UIFont.systemFont(ofSize: 14)
        cell?.contentConfiguration = config
        return cell!
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
            
            let data:EmployData = self.empList[indexPath.row]
            context?.delete(data)
            
            self.empList.remove(at: indexPath.row)
            self.tableview.reloadData()
            
            do {
                try context?.save()
            } catch {
                print(error)
            }
            
        }
    }
    
}

extension FetchEmpViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UpdateViewController") as! UpdateViewController
        vc.empData = self.empList[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
