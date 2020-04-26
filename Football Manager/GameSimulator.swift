//
//  GameSimulator.swift
//  Football Manager
//
//  Created by Stefan's FakeMac on 4/26/20.
//  Copyright © 2020 Stefan's FakeMacasasa. All rights reserved.
//

import Foundation
class GameSimulator{
    
    static func simulateRound(scoreb: ScoreBoard) -> ScoreBoard{
        let result = scoreb
        let round = scoreb.Rounds[scoreb.CurrentRound]
        for i in (0...round.Games.count){
            let gr = GameSimulator.simulateGame(home: round.Games[i].HomeTeam, away: round.Games[i].AwayTeam)
            round.Games[i].AwayGoals = gr.awayScore
            round.Games[i].HomeGoals = gr.homeScore
            
            result.updateTeamStatsByName(name: round.Games[i].HomeTeam.name, gs: gr.homeScore, gr: gr.awayScore)
            result.updateTeamStatsByName(name: round.Games[i].AwayTeam.name, gs: gr.awayScore, gr: gr.homeScore)            //to add round events
        }
        
        result.CurrentRound = result.CurrentRound + 1
        return result
    }
    
    static func simulateGame(home: Team, away: Team) -> GameResult{
        let random = arc4random_uniform(101)
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

