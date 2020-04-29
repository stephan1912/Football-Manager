//
//  ScoreBoard.swift
//  Football Manager
//
//  Created by Stefan's FakeMac on 4/26/20.
//  Copyright © 2020 Stefan's FakeMacasasa. All rights reserved.
//

import Foundation
class ScoreBoard: NSObject, NSCoding{
    var Season: String = ""
    var SeasonNumber: Int = 0
    var TeamS: [TeamStats] = []
    var CurrentRound: Int = 0
    var Rounds: [Round] = []
    
    func getGameResultInRound(round: Int, team: Team) -> Game?{
        for g in Rounds[round].Games{
            if g.HomeTeam.name == team.name || g.AwayTeam.name == team.name{
                return g
            }
        }
        return nil
    }
    
    func simulateRound(){
        let round = Rounds[CurrentRound - 1]
        for i in (0...round.Games.count - 1){
            for pl in round.Games[i].HomeTeam.players{
                round.Games[i].HomeTeam.setRedCard(player: pl, redCard: false)
                _ = round.Games[i].HomeTeam.setYellowCard(player: pl, card: false)
            }
            for pl in round.Games[i].AwayTeam.players{
                round.Games[i].AwayTeam.setRedCard(player: pl, redCard: false)
                _ = round.Games[i].AwayTeam.setYellowCard(player: pl, card: false)
            }
            let gr = GameSimulator.simulateGame(home: round.Games[i].HomeTeam, away: round.Games[i].AwayTeam)
            Rounds[CurrentRound - 1].Games[i].AwayGoals = gr.awayScore
            Rounds[CurrentRound - 1].Games[i].HomeGoals = gr.homeScore
            Rounds[CurrentRound - 1].Games[i].Events = gr.events
            updateTeamStatsByName(name: round.Games[i].HomeTeam.name, gs: gr.homeScore, gr: gr.awayScore)
            updateTeamStatsByName(name: round.Games[i].AwayTeam.name, gs: gr.awayScore, gr: gr.homeScore)  
            
        }
        
        CurrentRound = CurrentRound + 1
    }
    func setTeamByName(team: Team){
        for i in 0...TeamS.count{
            if TeamS[i].TeamS.name == team.name{
                TeamS[i].TeamS = team
                return
            }
        }
    }
    func getTeamByName(name: String) -> Team?{
        for ts in TeamS{
            if ts.TeamS.name == name{
                return ts.TeamS
            }
        }
        return nil
    }
    func updateTeamStatsByName(name: String, gs: Int, gr: Int){
        for ts in (0...TeamS.count - 1){
            if TeamS[ts].TeamS.name == name{
                TeamS[ts].updateStats(gs: gs, gr: gr)
                return
            }
        }
    }
    
    func getTeamStatsByName(name: String) ->TeamStats?{
        for ts in TeamS{
            if ts.TeamS.name == name{
                return ts
            }
        }
        return nil
    }
    
    func getNextOpponent(teamName: String) -> Team?{
        let tm = getTeamByName(name: teamName)
        if tm == nil {
            return nil
        }
        return Rounds[CurrentRound - 1].getOpponent(team: tm!)
    }
    
    override init(){}
    
    required init?(coder aDecoder: NSCoder) {
        self.Season = aDecoder.decodeObject(forKey: "season") as! String
        self.SeasonNumber = Int(aDecoder.decodeInt32(forKey: "seasonNumber"))
        self.CurrentRound = Int(aDecoder.decodeInt32(forKey: "currentRound"))
        self.TeamS = aDecoder.decodeObject(forKey: "teamS") as! [TeamStats]
        self.Rounds = aDecoder.decodeObject(forKey: "rounds") as! [Round]
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(Season, forKey: "season")
        aCoder.encode(SeasonNumber, forKey: "seasonNumber")
        aCoder.encode(CurrentRound, forKey: "currentRound")
        aCoder.encode(TeamS, forKey: "teamS")
        aCoder.encode(Rounds, forKey: "rounds")
    }
    
    func shuffle(arr: [Int]) -> [Int]{
        // empty and single-element collections don't shuffle
        if arr.count < 2 { return arr}
        var result = arr
        for i in 0 ..< arr.count - 1 {
            let j = Int(arc4random_uniform(UInt32(arr.count - i))) + i
            if i != j {
                let x = result[i]
                result[i] = result[j]
                result[j] = x
            }
        }
        return result
    }
        
    func generateSeason(league: League){
        SeasonNumber = SeasonNumber + 1
        Season = league.name + " - Seasone " + String(SeasonNumber)
        CurrentRound = 1
        var matrix1 = [[Int]]()
        matrix1.append([Int]())
        matrix1.append([Int]())
        let tn = league.Teams.count
        for i in (0...(tn / 2 - 1)){
            matrix1[0].append(i)
            matrix1[1].append(tn - i - 1)
        }
        var matrix = [[Int]]()
        matrix.append(shuffle(arr: matrix1[0]))
        matrix.append(shuffle(arr: matrix1[1]))
        let firstRound = Round()
        firstRound.RoundNumber = 1
        //firstRound.createFromMatrix(matrix: matrix, teams: league.Teams)
        //Rounds.append(firstRound)
        var firstHalf: [Round] = []
        for i in (1...tn - 1){
            let x = matrix[0][tn / 2 - 1]
            let y = matrix[1][0]
            for j in (1...(tn/2 - 1)){
                matrix[0][tn / 2 - j] = matrix[0][tn / 2 - j - 1]
                matrix[1][j - 1] = matrix[1][j]
            }
            matrix[0][1] = y
            matrix[1][tn / 2 - 1] = x
            let round = Round()
            round.RoundNumber = i// + 1
            round.createFromMatrix(matrix: matrix, teams: league.Teams)
            Rounds.append(round)
            firstHalf.append(round)
        }
        
        for r in firstHalf{
            let newR = Round()
            newR.RoundNumber = r.RoundNumber + firstHalf.count
            for g in r.Games{
                let newG = Game()
                newG.HomeTeam = g.AwayTeam
                newG.AwayTeam = g.HomeTeam
                newR.Games.append(newG)
            }
            Rounds.append(newR)
        }
        
        for el in league.Teams{
            let ts = TeamStats()
            ts.TeamS = el
            TeamS.append(ts)
        }
    }
}

