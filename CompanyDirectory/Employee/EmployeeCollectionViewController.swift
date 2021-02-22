//
//  EmployeeCollectionViewController.swift
//  CompanyDirectory
//
//  Created by 大林拓実 on 2021/02/17.
//

import UIKit

class EmployeeCollectionViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    var database: Database!
    var detailEmployee: Employee?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        database = Database()
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        database = Database()
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEmployeeDetail" {
            let vc = segue.destination as! EmployeeDetailViewController
            vc.employee = detailEmployee
        }
        if segue.identifier == "toEmployeeEdit" {
            let vc = segue.destination as! EditEmployeeViewController
            vc.delegate = self
        }
        
    }
    
}

extension EmployeeCollectionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        database.employees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        
        cell.imageView?.image = UIImage(systemName: "person.circle")
        cell.textLabel?.text = database.employees[indexPath.row].name
        cell.detailTextLabel?.text = database.employees[indexPath.row].teamName
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        detailEmployee = database.employees[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "toEmployeeDetail", sender: nil)
    }
    
}

extension EmployeeCollectionViewController: EditEmployeeProtocol {
    func viewDidDismiss() {
        database = Database()
        tableView.reloadData()
    }
}
