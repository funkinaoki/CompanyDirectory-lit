//
//  AppDelegate.swift
//  CompanyDirectory
//
//  Created by 大林拓実 on 2021/02/17.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // UserDefaultsクリア
        let appDomain = Bundle.main.bundleIdentifier
        UserDefaults.standard.removePersistentDomain(forName: appDomain!)
        
        let modelData = Database()
        
        // チームの初期データ
        let defaultTeams = [Team(name: "ファイナンス", description: "財務"),
                            Team(name: "エンジニアリング", description: "プロダクト開発"),
                            Team(name: "デザイン", description: "ユーザーインターフェース"),
                            Team(name: "マーケティング", description: "市場調査"),
                            Team(name: "法務", description: "法務処理"),
                            Team(name: "人事", description: "人事異動")]
        for team in defaultTeams {
            modelData.setTeamData(team)
        }
        
        // 従業員の初期データ
        let defaultEmployeeData = [Employee(name: "野坂雄介", isOnline: true, contactAddress: "090-1234-5678", teamID: defaultTeams[1].id),
                                   Employee(name: "横田龍之介", isOnline: true, contactAddress: "090-1111-2222", teamID: defaultTeams[2].id),
                                   Employee(name: "城之内恵美", isOnline: true, contactAddress: "090-2222-3333", teamID: defaultTeams[2].id),
                                   Employee(name: "西村里枝", isOnline: true, contactAddress: "090-4444-5555", teamID: defaultTeams[0].id)]
        for employee in defaultEmployeeData {
            modelData.setEmployeeData(employee)
        }
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

