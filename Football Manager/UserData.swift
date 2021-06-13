//
//  UserData.swift
//  Football Manager
//
//  Created by Stefan's FakeMac on 4/14/20.
//  Copyright © 2020 Stefan's FakeMacasasa. All rights reserved.
//

import Foundation
class UserData: NSObject, NSCoding{
    var Username: String = ""
    var Email: String = ""
    var Password: String = ""
    var ClubLeague: String = ""
    var ClubName: String = ""
    var ScoreB: Scoreboard = Scoreboard()
    
    
    override init(){
    }
    
    required init(coder decoder: NSCoder) {
        self.Username = decoder.decodeObject(forKey: "username") as! String
        self.Email = decoder.decodeObject(forKey: "email") as! String
        self.Password = decoder.decodeObject(forKey: "password") as! String
        self.ClubLeague = decoder.decodeObject(forKey: "clubLeague") as! String
        self.ClubName = decoder.decodeObject(forKey: "clubName") as! String
        self.ScoreB = decoder.decodeObject(forKey: "scoreB") as! Scoreboard
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(Username, forKey: "username")
        aCoder.encode(Email, forKey: "email")
        aCoder.encode(Password, forKey: "password")
        aCoder.encode(ClubLeague, forKey: "clubLeague")
        aCoder.encode(ClubName, forKey: "clubName")
        aCoder.encode(ScoreB, forKey: "scoreB")
    }
    
    var jsonRepresentation : String {
        let dict = ["UserName" : Username, "Email" : Email, "Password" : Password, "ClubLeague": ClubLeague, "ClubName": ClubName]
        
        let data =  try! JSONSerialization.data(withJSONObject: dict, options: [])
        return String(data:data, encoding:.utf8)!
    }
    
    func initFromJson(jsonString: String){
        let data = jsonString.data(using: .utf8)!
        let json = try? (JSONSerialization.jsonObject(with: data, options: []) as! [String: Any])
        Username = json?["UserName"] as! String
        Email = json?["Email"] as! String
        Password = json?["Password"] as! String
        ClubName = json?["ClubName"] as! String
        ClubLeague = json?["ClubLeague"] as! String
        
    }
    
    static func initFromDBUser(user: User) -> UserData{
        let result = UserData()
        result.Username = user.username
        result.Email = user.email
        result.Password = user.password
        result.ClubName = user.clubname
        result.ClubLeague = user.clubleague
        do{
            result.ScoreB = user.scoreboard
        }
        catch{
            print("Error decoding scoreboard!")
            return result;
        }
        //result.ScoreB = (NSKeyedUnarchiver.unarchiveObject(with: user.scoreboard.data(using: .utf8)!) as? Scoreboard)!
        return result
    }
    
    func getTeam() -> Team{
        return ScoreB.getTeamByName(name: ClubName)!
    }
    
    func setTeam(team: Team){
        ScoreB.setTeamByName(team: team)
    }
    
    func createScoreBoard(league: League){
        ScoreB.generateSeason(league: league)
    }
 
}








