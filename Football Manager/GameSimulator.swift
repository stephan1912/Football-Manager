//
//  GameSimulator.swift
//  Football Manager
//
//  Created by Stefan's FakeMac on 4/26/20.
//  Copyright © 2020 Stefan's FakeMacasasa. All rights reserved.
//

import Foundation
class GameSimulator{
    
    
    static func simulateGame(home: Team, away: Team) -> GameResult{
        let random = arc4random_uniform(101)
        
        for pl in home.players{
            if arc4random_uniform(100) < 10{
                home.setRedCard(player: pl, redCard: true)
            }
        }
        for pl in away.players{
            if arc4random_uniform(100) < 10{
                away.setRedCard(player: pl, redCard: true)
            }
        }
        
        if random < 33 {
            let rez = GameResult()
            rez.winningTeam = home
            rez.losingTeam = away
            rez.homeScore = Int(arc4random_uniform(5)) + 1
            rez.awayScore = Int(arc4random_uniform(UInt32(rez.homeScore)))
            return rez
            
         }
        else if random < 66{
            let rez = GameResult()
            rez.winningTeam = away
            rez.losingTeam = home
            rez.awayScore = Int(arc4random_uniform(5)) + 1
            rez.homeScore = rez.awayScore
            return rez
        }
        else {
            let rez = GameResult()
            rez.winningTeam = away
            rez.losingTeam = home
            rez.awayScore = Int(arc4random_uniform(5)) + 1
            rez.homeScore = Int(arc4random_uniform(UInt32(rez.awayScore)))
            return rez
        }
    }
}

