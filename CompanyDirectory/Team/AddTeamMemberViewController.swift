//
//  AddTeamMemberViewController.swift
//  CompanyDirectory
//
//  Created by 大林拓実 on 2021/02/21.
//

import UIKit

protocol AddTeamMemberProtocol {
    func viewDidDismiss()
}

class AddTeamMemberViewController: UIViewController {
    var delegate: AddTeamProtocol?
    var database: Database?
    
    @IBOutlet var tableView: UITableView!
    
    var team: Team!
    var canAddMembers: [Employee] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        database = Database()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        canAddMembers = database?.employees.filter({ $0.teamID != team.id }) ?? []
    }
    
}

extension AddTeamMemberViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        canAddMembers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        
        cell.imageView?.image = UIImage(systemName: "person.circle")
        cell.textLabel?.text = canAddMembers[indexPath.row].name
        cell.detailTextLabel?.text = canAddMembers[indexPath.row].teamName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectMember = database?.employees.first(where: {$0.id == canAddMembers[indexPath.row].id})
        selectMember?.joinTeam(by: team.name)
        delegate?.viewDidDismiss()
        dismiss(animated: true, completion: nil)
    }
    
}
