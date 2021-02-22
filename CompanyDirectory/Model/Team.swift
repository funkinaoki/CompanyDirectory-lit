//
//  Team.swift
//  CompanyDirectory
//
//  Created by 大林拓実 on 2021/02/17.
//

import Foundation

struct Team: Codable {
    /* ここから */
    var id = UUID()
    var name: String
    var description: String
    /* ここまで */
    
    func getTeamMembers() -> [Employee] {
        let database = Database()
        let allMember = database.employees
        return allMember.filter { $0.teamID == id }
    }
    
    func save() {
        let database = Database()
        database.setTeamData(self)
    }
    
    func delete() {
        let database = Database()
        do {
            try database.deleteTeamData(self)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func addMembers(by id: UUID) {
        let database = Database()
        var employee = database.employees.filter { $0.id == id }.first
        employee?.joinTeam(by: name)
    }
    
    func removeMembers(by id: UUID) {
        let database = Database()
        var employee = database.employees.filter { $0.id == id }.first
        employee?.leaveTeam()
    }
}
