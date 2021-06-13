//
//  AppUsers.swift
//  Football Manager
//
//  Created by Stefan's FakeMac on 4/14/20.
//  Copyright © 2020 Stefan's FakeMacasasa. All rights reserved.
//

import Foundation
import UIKit
import CoreData
class AppUsers{
    
    private static var CurrentUser = UserData()
    
    private static var Users: [UserData] = []
    private static var loaded: Bool = false
    private static let storageKey: String = "_appUsers";
    
    static func getAllUsers(context: NSManagedObjectContext) -> [UserData]{
        if loaded == false{
            loadData(context: context)
        }
        return Users
    }
    
    static func saveCurrentUserData(context: NSManagedObjectContext){
        if loaded == false {
            loadData(context: context)
        }
        for i in 0...Users.count{
            if Users[i].Username == CurrentUser.Username{
                Users[i] = CurrentUser
                /*
                let encodedData = NSKeyedArchiver.archivedData(withRootObject: Users)
                UserDefaults.standard.set(encodedData, forKey: storageKey)
                */
                do{
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
                    fetchRequest.predicate = NSPredicate(format: "username = %@", CurrentUser.Username)

                    if let fetchResults = try context.fetch(fetchRequest) as? [NSManagedObject] {
                        if fetchResults.count != 0{

                            let managedObject = fetchResults[0]
                            //let scoreBoard = String(data: try NSKeyedArchiver.archivedData(withRootObject: CurrentUser.ScoreB, requiringSecureCoding: false), encoding: .utf8)
                            managedObject.setValue(CurrentUser.ScoreB, forKey: "scoreboard")

                            try context.save()
                        }
                    }
                }
                catch{
                    print("Error on save")
                }
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
    
    static func removeUser(user: UserData, context: NSManagedObjectContext){
        for i in 0...Users.count-1{
            if Users[i].Username == user.Username{
                do{
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
                    fetchRequest.predicate = NSPredicate(format: "username = %@", user.Username)

                    if let fetchResults = try context.fetch(fetchRequest) as? [NSManagedObject] {
                        if fetchResults.count != 0{
                            context.delete(fetchResults[0])
                            try context.save()
                        }
                    }
                     Users.remove(at: i)
                    
                }
                catch{
                    print("Error on save")
                }
                break
                
            }
        }
        
        /*
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: Users)
        UserDefaults.standard.set(encodedData, forKey: storageKey)
         */
        loaded = false
    }
    
    static func clearData(){
        UserDefaults.standard.removeObject(forKey: storageKey)
    }
    
    static func addUser(user: UserData, context: NSManagedObjectContext) -> Bool{
        if checkIfUserExists(uname: user.Username, context: context){
            return false
        }
        
        
        let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
        let newUser = User(entity: entity!, insertInto: context)
        newUser.username = user.Username
        newUser.email = user.Email
        newUser.password = user.Password
        newUser.clubname = user.ClubName
        newUser.clubleague = user.ClubLeague
        
        do{
            let data = try NSKeyedArchiver.archivedData(withRootObject: user.ScoreB, requiringSecureCoding: false)
            //let scoreboard = String(data: data, encoding: .utf8)!// as! String
            newUser.scoreboard = user.ScoreB //data//scoreboard
            try context.save()
            Users.append(user)
        }
        catch{
            print("Could not add user")
            return false
        }
        
        /*
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: Users)
        UserDefaults.standard.set(encodedData, forKey: storageKey)
        */
        return true;
    }
    
    static func checkIfUserExists(uname: String, context: NSManagedObjectContext) -> Bool{
        do{
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
            fetchRequest.predicate = NSPredicate(format: "username = %@", uname)

            if let fetchResults = try context.fetch(fetchRequest) as? [NSManagedObject] {
                if fetchResults.count != 0{
                    return true
                }
            }
        }
        catch{
            print("Error on check username")
            return true
        }
        
        return false
    }
    
    static func getUser(uname: String, context: NSManagedObjectContext) -> UserData? {
        if loaded == false {
            loadData(context: context)
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
    
    static func validateUserCredentials(uname: String, password: String, context: NSManagedObjectContext) -> UserData? {
        if loaded == false {
            loadData(context: context)
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
    
    static func loadData(context: NSManagedObjectContext){
        
        //var dbUsers = [DBUser]()
        Users = [UserData]()
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        do{
            let results:NSArray = try context.fetch(request) as NSArray
            for result in results
            {
                let user = result as! User
                self.Users.append(UserData.initFromDBUser(user: user))
                //dbUsers.append(user)
            }
            self.loaded = true
            
        }
        catch{
            print("Fetch Failed");
        }
        /*
        if let data = UserDefaults.standard.data(forKey: storageKey),
            let appUsers = NSKeyedUnarchiver.unarchiveObject(with: data) as? [UserData]{
            self.Users = appUsers
            self.loaded = true
        }
         */
    }
}
