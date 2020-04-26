//
//  Game.swift
//  Football Manager
//
//  Created by Stefan's FakeMac on 4/26/20.
//  Copyright © 2020 Stefan's FakeMacasasa. All rights reserved.
//

import Foundation
class Game: NSObject, NSCoding{
    var HomeTeam: Team = Team()
    var AwayTeam: Team = Team()
    var HomeGoals: Int = 0
    var AwayGoals: Int = 0
    
    required init?(coder aDecoder: NSCoder) {
        self.AwayGoals = Int(aDecoder.decodeInt32(forKey: "awayGoals"))
        self.HomeGoals = Int(aDecoder.decodeInt32(forKey: "homeGoals"))
        self.AwayTeam = aDecoder.decodeObject(forKey: "awayTeam") as! Team
        self.HomeTeam = aDecoder.decodeObject(forKey: "homeTeam") as! Team
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(AwayGoals, forKey: "awayGoals")
        aCoder.encode(HomeGoals, forKey: "homeGoals")
        aCoder.encode(AwayTeam, forKey: "awayTeam")
        aCoder.encode(HomeTeam, forKey: "homeTeam")
    }
    
    override init(){}
}
