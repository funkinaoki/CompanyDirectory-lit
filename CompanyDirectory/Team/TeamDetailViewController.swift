//
//  TeamDetailViewController.swift
//  CompanyDirectory
//
//  Created by 大林拓実 on 2021/02/17.
//

import UIKit

class TeamDetailViewController: UIViewController {
    let database = Database()

    var team: Team?
    var teamMember: [Employee]?
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        imageView.image = UIImage(systemName: "person.circle")
        
        if let team = team {
            teamMember = team.getTeamMembers()
            nameLabel.text = team.name
            descriptionLabel.text = team.description
        } else {
            teamMember = database.employees.filter({ $0.teamID == nil })
            nameLabel.text = "なし"
            descriptionLabel.text = "所属チームがありません"
            navigationItem.rightBarButtonItem = nil
        }
        
    }
    
    @IBAction func editTapped() {
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped))
            navigationItem.leftBarButtonItem = nil
        } else {
            tableView.setEditing(true, animated: true)
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(editTapped))
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        }
    }
    
    @objc func addTapped() {
        performSegue(withIdentifier: "toAddTeamMember", sender: nil)
        editTapped()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddTeamMember" {
            let vc = segue.destination as! AddTeamMemberViewController
            vc.team = team
            vc.delegate = self
        }
        if segue.identifier == "toEmployeeDetail" {
            let vc = segue.destination as! EmployeeDetailViewController
            vc.employee = sender as? Employee
        }
    }
    
}

extension TeamDetailViewController: AddTeamProtocol {
    func viewDidDismiss() {
        teamMember = team?.getTeamMembers()
        tableView.reloadData()
    }
}

extension TeamDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamMember?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = teamMember?[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "toEmployeeDetail", sender: teamMember?[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let willRemoveMember = database.employees.first(where: { $0.id == teamMember?[indexPath.row].id } )!
            team?.removeMembers(by: willRemoveMember.id)
            team?.save()
            
            teamMember = team?.getTeamMembers()
            tableView.reloadData()
            
        }
    }
    
}
