//
//  Round.swift
//  Football Manager
//
//  Created by Stefan's FakeMac on 4/26/20.
//  Copyright © 2020 Stefan's FakeMacasasa. All rights reserved.
//

import Foundation

class  Round: NSObject, NSCoding{
    var RoundNumber: Int = 0
    var Games: [Game] = []
    
    required init?(coder aDecoder: NSCoder) {
        self.RoundNumber = Int(aDecoder.decodeInt32(forKey: "roundNumber"))
        self.Games = aDecoder.decodeObject(forKey: "games") as! [Game]
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(RoundNumber, forKey: "roundNumber")
        aCoder.encode(Games, forKey: "games")
    }
    
    override init(){
        
    }
    func createFromMatrix(matrix: [[Int]], teams: [Team]){
        for i in (0...matrix[0].count - 1){
            let game = Game()
            game.HomeTeam = teams[matrix[0][i]]
            game.AwayTeam = teams[matrix[1][i]]
            Games.append(game)
        }
    }
    
    func getOpponent(team: Team) -> Team?{
        for game in Games{
            if game.AwayTeam.name == team.name {
                return game.HomeTeam
            }
            else if game.HomeTeam.name == team.name{
                return game.AwayTeam
            }
        }
        return nil
    }
}
