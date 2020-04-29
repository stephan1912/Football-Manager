//
//  TeamStats.swift
//  Football Manager
//
//  Created by Stefan's FakeMac on 4/26/20.
//  Copyright © 2020 Stefan's FakeMacasasa. All rights reserved.
//

import Foundation

class TeamStats: NSObject, NSCoding{
    var TeamS: Team = Team()
    var GoalsScored: Int = 0
    var GoalsRecv: Int = 0
    var GamesPlayed: Int = 0
    var Points: Int = 0
    
    func updateStats(gs: Int, gr: Int){
        GoalsRecv = GoalsRecv + gr
        GoalsScored = GoalsScored + gs
        GamesPlayed = GamesPlayed + 1
        if gs == gr {
            Points = Points + 1
        }
        else if gs > gr {
            Points = Points + 3
        }
        for i in (0...TeamS.players.count - 1){
            if TeamS.players[i].teamRole == TeamRoles.StartingXI{
                TeamS.players[i].stamina  = TeamS.players[i].stamina - (Int(arc4random_uniform(8)) + 2)
            }
            else if TeamS.players[i].teamRole == TeamRoles.Substitue{
                TeamS.players[i].stamina  = TeamS.players[i].stamina - (Int(arc4random_uniform(2)) + 2)
            }
        }
    }
    
    override init(){}
    
    required init?(coder aDecoder: NSCoder) {
        self.TeamS = aDecoder.decodeObject(forKey: "teamS") as! Team
        self.GoalsScored = Int(aDecoder.decodeInt32(forKey: "goalsScored"))
        self.GoalsRecv = Int(aDecoder.decodeInt32(forKey: "goalsRecv"))
        self.GamesPlayed = Int(aDecoder.decodeInt32(forKey: "gamesPlayed"))
        self.Points = Int(aDecoder.decodeInt32(forKey: "points"))
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(TeamS, forKey: "teamS")
        aCoder.encode(GoalsScored, forKey: "goalsScored")
        aCoder.encode(GoalsRecv, forKey: "goalsRecv")
        aCoder.encode(GamesPlayed, forKey: "gamesPlayed")
        aCoder.encode(Points, forKey: "points")
    }
}
