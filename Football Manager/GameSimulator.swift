//
//  GameSimulator.swift
//  Football Manager
//
//  Created by Stefan's FakeMac on 4/26/20.
//  Copyright © 2020 Stefan's FakeMacasasa. All rights reserved.
//

import Foundation

enum  FieldPos: String {
    case MID = "midfield"
    case DEF = "defense"
    case ATT = "attack"
    case CORNER = "corner"
}

class GameSimulator{
    
    
    static func getOvrWithStamina(players: [Player]) -> Int{
        var ovr = 0
        for p in players {
            ovr = ovr + Int(Double(p.rating * p.stamina) / 100.0)
        }
        if ovr == 0 {
            return Int(arc4random_uniform(20) + 70)
        }
        ovr = ovr / players.count
        return ovr
    }
    
    static func getRandomResult(a: Int, b: Int) -> Int{
        let aPer = Int((Double(a) / Double((a + b))) * 100.0)
        let bPer = Int((Double(b) / Double((a + b))) * 100.0)
        
        let rn = Int(arc4random_uniform(UInt32(aPer + bPer)))
        
        if  rn < aPer {
            return 1
        }
        else if rn >= aPer && rn < aPer + bPer{
            return 2
        }
        return 0
    }
    
    static func simulateCard(otherTeam: Team, i: Int, playerRole: PlayerRole) -> GameEvent? {
        //return nil
        //sanse de 4% pt echipa care nu are mingea sa faulteze si sa obitna rosu, in acest caz se trece peste restul verificarilor
        let redCardRand = arc4random_uniform(100)
        if redCardRand < 3{
            let pl = otherTeam.setRandomRedCard(role: playerRole)
            let evName = pl.name + "(" + otherTeam.name + ")" + EventType.CatonasR.rawValue
            return GameEvent(event: evName, min: i)
        }
        //sanse de 8% pt yellowCard
        if redCardRand < 6{
            let pl = otherTeam.setRandomYellowCard(role: playerRole)
            if pl.redCard{
                //red card
                let evName = pl.name + "(" + otherTeam.name + ")" + EventType.CatonasR.rawValue
                return GameEvent(event: evName, min: i)
            }
            else {
                //yellow
                let evName = pl.name + "(" + otherTeam.name + ")" + EventType.CatonasG.rawValue
                return GameEvent(event: evName, min: i)
            }
        }
        return nil
    }
    
    static func simulateGame(home: Team, away: Team) -> GameResult{
        
        var currentTeam = home
        var currentGoals = 0
        var otherTeam = away
        var otherGoals = 0
        
        currentTeam.resetGameYellowcards()
        otherTeam.resetGameYellowcards()
        
        let gameResult = GameResult()
        let random = arc4random_uniform(101)
        
        if random < 50 {
            swap(&currentTeam, &otherTeam)
            swap(&currentGoals, &otherGoals)
        }
        
        gameResult.events.append(GameEvent(event: currentTeam.name + EventType.Start.rawValue, min: 0))
        gameResult.events.append(GameEvent(event: currentTeam.name + EventType.Posesie.rawValue, min: 1))
        
        var position = FieldPos.MID
        
        for i in 2...90 {
            if position == FieldPos.MID{
                
                //simuleaza catonase
                let cardSim = simulateCard(otherTeam: otherTeam, i: i, playerRole: PlayerRole.CM)
                if cardSim != nil {
                    gameResult.events.append(cardSim!)
                    continue
                }
                
                
                let cTeamOvr = getOvrWithStamina(players: currentTeam.getPlayerByRoleInStartingXi(role: PlayerRole.CM))
                let oTeamOvr = getOvrWithStamina(players: otherTeam.getPlayerByRoleInStartingXi(role: PlayerRole.CM))
                let result = getRandomResult(a: cTeamOvr, b: oTeamOvr)
                if result == 1 { //echipa care are deja posesia trece in atac
                    position = FieldPos.ATT
                    let evName = currentTeam.name + EventType.Atac.rawValue
                    gameResult.events.append(GameEvent(event: evName, min: i))
                }
                else{ // otherTeam recupereaza mingea si devine currentTeam, pozitia ramane mid
                    swap(&currentTeam, &otherTeam)
                    swap(&currentGoals, &otherGoals)
                    let evName = currentTeam.name + EventType.Posesie.rawValue
                    gameResult.events.append(GameEvent(event: evName, min: i))
                }
            }
            else if position == FieldPos.DEF{
                //simuleaza catonase
                let cardSim = simulateCard(otherTeam: otherTeam, i: i, playerRole: PlayerRole.ST)
                if cardSim != nil {
                    gameResult.events.append(cardSim!)
                    continue
                }
                //echipa curenta e in defensiva, other team incearca sa recupereze
                
                
                let cTeamOvr = getOvrWithStamina(players: currentTeam.getPlayerByRoleInStartingXi(role: PlayerRole.CB))
                let oTeamOvr = getOvrWithStamina(players: otherTeam.getPlayerByRoleInStartingXi(role: PlayerRole.ST))
                let result = getRandomResult(a: cTeamOvr, b: oTeamOvr)
                if result == 1 { //echipa care are deja posesia trece in mid
                    position = FieldPos.MID
                    let evName = currentTeam.name + EventType.Posesie.rawValue
                    gameResult.events.append(GameEvent(event: evName, min: i))
                }
                else{ // otherTeam recupereaza mingea si devine currentTeam, potitia ATT
                    swap(&currentTeam, &otherTeam)
                    swap(&currentGoals, &otherGoals)
                    position = FieldPos.ATT
                    let evName = currentTeam.name + EventType.Atac.rawValue
                    gameResult.events.append(GameEvent(event: evName, min: i))
                }
            }
            else if position == FieldPos.ATT{
                //simuleaza catonase
                let cardSim = simulateCard(otherTeam: otherTeam, i: i, playerRole: PlayerRole.CB)
                if cardSim != nil {
                    gameResult.events.append(cardSim!)
                    continue
                }
                //echipa curenta e in atac, other team se apara
                
                
                let cTeamOvr = getOvrWithStamina(players: currentTeam.getPlayerByRoleInStartingXi(role: PlayerRole.ST))
                let oTeamOvr = getOvrWithStamina(players: otherTeam.getPlayerByRoleInStartingXi(role: PlayerRole.CB))
                let result = getRandomResult(a: cTeamOvr, b: oTeamOvr)
                if result == 1 { //echipa care ataca trage la poarta
                    let gkOvr = getOvrWithStamina(players: otherTeam.getPlayerByRoleInStartingXi(role: PlayerRole.GK))
                    let randomAtt = currentTeam.getRandomPlayerInStartingXi(role: PlayerRole.ST)
                    let attOvr = (randomAtt.rating * randomAtt.stamina) / 100
                    
                    let shotRes = getRandomResult(a: gkOvr, b: attOvr)
                    
                    if shotRes == 1{
                        let corner = arc4random_uniform(100)
                        if corner < 20 {
                            //goooool
                            let evName = randomAtt.name + EventType.Gol.rawValue + currentTeam.name
                            gameResult.events.append(GameEvent(event: evName, min: i))
                            currentGoals = currentGoals + 1
                            swap(&currentTeam, &otherTeam)
                            swap(&currentGoals, &otherGoals)
                            position = FieldPos.MID
                        }
                        else if corner < 50 {
                            //corner
                            let evName = currentTeam.name + EventType.Corner.rawValue
                            gameResult.events.append(GameEvent(event: evName, min: i))
                            position = FieldPos.CORNER
                        }
                        else{
                            swap(&currentTeam, &otherTeam)
                            swap(&currentGoals, &otherGoals)
                            position = FieldPos.ATT
                            
                            let evName = currentTeam.name + EventType.Posesie.rawValue
                            gameResult.events.append(GameEvent(event: evName, min: i))
                        }
                    }
                    
                }
                else{ // otherTeam recupereaza mingea si devine currentTeam, potitia ATT
                    swap(&currentTeam, &otherTeam)
                    swap(&currentGoals, &otherGoals)
                    position = FieldPos.DEF
                    
                    let evName = currentTeam.name + EventType.Posesie.rawValue
                    gameResult.events.append(GameEvent(event: evName, min: i))
                }
                
            }
            else if position == FieldPos.CORNER{
                let rand = arc4random_uniform(100)
                if rand < 25{
                    let randPlInd = Int(arc4random_uniform(UInt32(currentTeam.players.count)))
                    let randomAtt = currentTeam.players[randPlInd]
                    let evName = randomAtt.name + EventType.Gol.rawValue + currentTeam.name
                    gameResult.events.append(GameEvent(event: evName, min: i))
                    currentGoals = currentGoals + 1
                    swap(&currentTeam, &otherTeam)
                    swap(&currentGoals, &otherGoals)
                    position = FieldPos.MID
                }
                else{
                    swap(&currentTeam, &otherTeam)
                    swap(&currentGoals, &otherGoals)
                    position = FieldPos.DEF
                    
                    let evName = currentTeam.name + EventType.Posesie.rawValue
                    gameResult.events.append(GameEvent(event: evName, min: i))
                }
            }
        }
        
        if currentTeam.name == home.name{
            gameResult.awayScore = otherGoals
            gameResult.awayTeam = otherTeam
            gameResult.homeScore = currentGoals
            gameResult.homeTeam = currentTeam
        }
        else{
            gameResult.awayScore = currentGoals
            gameResult.awayTeam = currentTeam
            gameResult.homeScore = otherGoals
            gameResult.homeTeam = otherTeam
        }
        
        return gameResult
    }
}

