//
//  Employee.swift
//  CompanyDirectory
//
//  Created by 大林拓実 on 2021/02/17.
//

import Foundation

struct Employee: Codable {
    /* ここから */
    var id = UUID()
    var name: String
    var isOnline: Bool
    var contactAddress: String
    var teamID: UUID?
    /* ここまで */

    var teamName: String {
        let database = Database()
        guard let teamID = self.teamID else { return "なし" }
        
        let team = database.teams.first(where: { $0.id == teamID })
        return team?.name ?? "なし"
    }
    
    func save() {
        let database = Database()
        database.setEmployeeData(self)
    }
    
    func delete() {
        let database = Database()
        do {
            try database.deleteEmployeeData(self)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    mutating func joinTeam(by name: String) {
        let database = Database()
        let team = database.teams.filter { $0.name == name }.first
        self.teamID = team?.id
        save()
    }
    
    mutating func leaveTeam() {
        self.teamID = nil
        save()
    }
    
}

