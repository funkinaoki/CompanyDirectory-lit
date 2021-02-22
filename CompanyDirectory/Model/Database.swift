//
//  ModelData.swift
//  CompanyDirectory
//
//  Created by 大林拓実 on 2021/02/20.
//

import Foundation

enum DatabaseError: Error, LocalizedError {
    case notFound
    
    var errorDescription: String? {
        switch self {
            case .notFound:
                return "該当のデータは見つかりませんでした。"
        }
    }
}

final class Database {
    // MARK: - internal property
    var employees: [Employee] {
        getEmployeesData()
    }
    
    var teams: [Team] {
        getTeamsData()
    }
    
    // MARK: - CUD methods
    func setEmployeeData(_ employee: Employee) {
        var newEmployees = employees
        if let index = newEmployees.firstIndex(where: { return $0.id == employee.id }) {
            newEmployees[index] = employee
        } else {
            newEmployees.append(employee)
        }
        setEmployeesData(newEmployees)
    }
    
    func deleteEmployeeData(_ employee: Employee) throws {
        var newEmployees = employees
        if let index = newEmployees.firstIndex(where: { return $0.id == employee.id }) {
            newEmployees.remove(at: index)
            setEmployeesData(newEmployees)
        } else {
            throw DatabaseError.notFound
        }
    }
    
    func setTeamData(_ team: Team) {
        var newTeams = teams
        if let index = newTeams.firstIndex(where: { return $0.id == team.id }) {
            newTeams[index] = team
        } else {
            newTeams.append(team)
        }
        setTeamsData(newTeams)
    }
    
    func deleteTeamData(_ team: Team) throws {
        var newTeams = teams
        if let index = newTeams.firstIndex(where: { return $0.id == team.id }) {
            newTeams.remove(at: index)
            setTeamsData(newTeams)
        } else {
            throw DatabaseError.notFound
        }
    }
}

extension Database {
    // MARK: - Employees Read and Update
    private func getEmployeesData() -> [Employee] {
        guard let items = UserDefaults.standard.array(forKey: "employees") as? [Data] else { return [] }
        
        let decodedItems = items.map { try! JSONDecoder().decode(Employee.self, from: $0) }
        return decodedItems
    }
    
    private func setEmployeesData(_ employees: [Employee]) {
        let encodedEmployeesData = employees.map { try? JSONEncoder().encode($0) }
        UserDefaults.standard.register(defaults: ["employees": encodedEmployeesData])
    }
    
    // MARK: - Teams Read and Update
    private func getTeamsData() -> [Team] {
        guard let items = UserDefaults.standard.array(forKey: "teams") as? [Data] else { return [] }
        
        let decodedItems = items.map { try! JSONDecoder().decode(Team.self, from: $0) }
        return decodedItems
    }
    
    private func setTeamsData(_ teams: [Team]) {
        let encodedTeamsData = teams.map { try? JSONEncoder().encode($0) }
        UserDefaults.standard.register(defaults: ["teams": encodedTeamsData])
    }
}
