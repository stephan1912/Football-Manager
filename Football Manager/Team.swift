//
//  Team.swift
//  Football Manager
//
//  Created by Stefan's FakeMac on 4/13/20.
//  Copyright © 2020 Stefan's FakeMacasasa. All rights reserved.
//

import Foundation


class Team: NSObject, NSCoding {
    var name: String = "";
    var league: String = "";
    var country: String = "";
    var manager: String = "";
    var players: [Player] = []
    override init() {
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.league = aDecoder.decodeObject(forKey: "league") as! String
        self.country = aDecoder.decodeObject(forKey: "country") as! String
        self.manager = aDecoder.decodeObject(forKey: "manager") as! String
        self.players = aDecoder.decodeObject(forKey: "players") as! [Player]
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(league, forKey: "league")
        aCoder.encode(country, forKey: "country")
        aCoder.encode(manager, forKey: "manager")
        aCoder.encode(players, forKey: "players")
    }
    
    func performCheck() -> GameError{
        for player in players{
            if player.teamRole != TeamRoles.Reserved{
                if player.redCard{
                    return GameError.RedCard
                }
                if player.stamina < 70 {
                    return GameError.Lowstam
                }
            }
        }
        return GameError.NoError
    }
    
    func setRedCard(player: Player, redCard: Bool){
        for i in 0...players.count-1{
            if players[i].name == player.name{
                players[i].redCard = redCard
            }
        }
    }
    
    func generateStarting11(){
        let gks = getPlayerByRole(role: "gk").sorted(by: {$0.rating > $1.rating})
        for i in (0...gks.count - 1){
            if i < 1{
                setPlayerTeamRole(player: gks[i], teamRole: TeamRoles.StartingXI)
            }
            else if i < 2{
                setPlayerTeamRole(player: gks[i], teamRole: TeamRoles.Substitue)
            }
            else{
                setPlayerTeamRole(player: gks[i], teamRole: TeamRoles.Reserved)
            }
        }

        
        let cbs = getPlayerByRole(role: "cb").sorted(by: {$0.rating > $1.rating})
        for i in (0...cbs.count - 1){
            if i < 4{
                setPlayerTeamRole(player: cbs[i], teamRole: TeamRoles.StartingXI)
            }
            else if i < 6{
                setPlayerTeamRole(player: cbs[i], teamRole: TeamRoles.Substitue)
            }
            else{
                setPlayerTeamRole(player: cbs[i], teamRole: TeamRoles.Reserved)
            }
        }
        
        let cms = getPlayerByRole(role: "cm").sorted(by: {$0.rating > $1.rating})
        for i in (0...cms.count - 1){
            if i < 4{
                setPlayerTeamRole(player: cms[i], teamRole: TeamRoles.StartingXI)
            }
            else if i < 6{
                setPlayerTeamRole(player: cms[i], teamRole: TeamRoles.Substitue)
            }
            else{
                setPlayerTeamRole(player: cms[i], teamRole: TeamRoles.Reserved)
            }
        }
        let sts = getPlayerByRole(role: "st").sorted(by: {$0.rating > $1.rating})
        for i in (0...sts.count - 1){
            if i < 2{
                setPlayerTeamRole(player: sts[i], teamRole: TeamRoles.StartingXI)
            }
            else if i < 4{
                setPlayerTeamRole(player: sts[i], teamRole: TeamRoles.Substitue)
            }
            else{
                setPlayerTeamRole(player: sts[i], teamRole: TeamRoles.Reserved)
            }
        }
        let xi = getPlayerByTeamRole(role: TeamRoles.StartingXI)
        var subs = getPlayerByTeamRole(role: TeamRoles.Substitue)
        if xi.count < 11 {
            for _ in 0...(11 - xi.count - 1){
                if subs.count > 0{
                    setPlayerTeamRole(player: subs[0], teamRole: TeamRoles.StartingXI)
                    subs = getPlayerByTeamRole(role: TeamRoles.Substitue)
                }
            }
        }
        var res = getPlayerByTeamRole(role: TeamRoles.Reserved)
        if subs.count < 7 {
            for _ in 0...(7 - subs.count - 1){
                if res.count > 0{
                    setPlayerTeamRole(player: res[0], teamRole: TeamRoles.Substitue)
                    res = getPlayerByTeamRole(role: TeamRoles.Reserved)
                }
            }
        }
    }
    
    
    
    func setPlayerTeamRole(player: Player, teamRole: TeamRoles) {
        for i in (0...players.count - 1){
            if players[i].name == player.name{
                players[i].teamRole = teamRole
            }
        }
    }
    
    func changePlayers(player1: Player, player2: Player){
        let role = player1.teamRole
        player1.teamRole = player2.teamRole
        player2.teamRole = role
        /*for i in (0...players.count - 1){
            if players[i].name == player1.name{
                players[i].teamRole = player2.teamRole
            }
            else if players[i].name == player2.name{
                players[i].teamRole = player1.teamRole
            }
        }*/
    }
    
    func getPlayerByRole(role: String) -> [Player]{
        var result: [Player] = []
        for player in players{
            if player.role.lowercased() == role.lowercased() {
                result.append(player)
            }
        }
        return result
    }
    
    func getPlayerByTeamRole(role: TeamRoles) -> [Player]{
        var result: [Player] = []
        for player in players{
            if player.teamRole == role {
                result.append(player)
            }
        }
        return result
    }
}

enum GameError: String{
    case RedCard = "Ai jucatori in formatia de start care au cartonas rosu!"
    case Lowstam = "Ai jucatori in formatia de start care au stamina < 70!"
    case NoError = ""
}
enum TeamRoles: String{
    case StartingXI = "StartingX1"
    case Substitue = "Substitute"
    case Reserved = "Reserved"
}
