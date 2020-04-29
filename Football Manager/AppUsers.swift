//
//  AppUsers.swift
//  Football Manager
//
//  Created by Stefan's FakeMac on 4/14/20.
//  Copyright © 2020 Stefan's FakeMacasasa. All rights reserved.
//

import Foundation
class AppUsers{
    
    private static var CurrentUser = UserData()
    
    private static var Users: [UserData] = []
    private static var loaded: Bool = false
    private static let storageKey: String = "_appUsers";
    
    static func getAllUsers() -> [UserData]{
        if loaded == false{
            loadData()
        }
        return Users
    }
    
    static func saveCurrentUserData(){
        if loaded == false {
            loadData()
        }
        for i in 0...Users.count{
            if Users[i].Username == CurrentUser.Username{
                Users[i] = CurrentUser
                
                let encodedData = NSKeyedArchiver.archivedData(withRootObject: Users)
                UserDefaults.standard.set(encodedData, forKey: storageKey)
                return
            }
        }
    }
    
    static func getCurrentUser() -> UserData{
        return AppUsers.CurrentUser
    }
    
    static func setCurrentUser(user: UserData){
        CurrentUser = user
    }
    
    static func removeUser(user: UserData){
        for i in 0...Users.count-1{
            if Users[i].Username == user.Username{
                Users.remove(at: i)
                break            }
        }
        
        
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: Users)
        UserDefaults.standard.set(encodedData, forKey: storageKey)
        loaded = false
    }
    
    static func clearData(){
        UserDefaults.standard.removeObject(forKey: storageKey)
    }
    
    static func addUser(user: UserData) -> Bool{
        if checkIfUserExists(uname: user.Username){
            return false
        }
        
        Users.append(user)
        
        
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: Users)
        UserDefaults.standard.set(encodedData, forKey: storageKey)
        
        return true;
    }
    
    static func checkIfUserExists(uname: String) -> Bool{
        if loaded == false {
            loadData()
        }
        if Users.count == 0 {
            return false;
        }
        for user in Users{
            if user.Username == uname {
                return true
            }
        }
        
        return false
    }
    
    static func getUser(uname: String) -> UserData? {
        if loaded == false {
            loadData()
        }
        if Users.count == 0 {
            return nil;
        }
        for user in Users{
            if user.Username == uname {
                return user
            }
        }
        
        return nil
    }
    
    static func validateUserCredentials(uname: String, password: String) -> UserData? {
        if loaded == false {
            loadData()
        }
        if Users.count == 0 {
            return nil;
        }
        for user in Users{
            if user.Username == uname && user.Password == password{
                return user
            }
        }
        
        return nil
    }
    
    static func loadData(){
        if let data = UserDefaults.standard.data(forKey: storageKey),
            let appUsers = NSKeyedUnarchiver.unarchiveObject(with: data) as? [UserData]{
            self.Users = appUsers
            self.loaded = true
        }
    }
}
