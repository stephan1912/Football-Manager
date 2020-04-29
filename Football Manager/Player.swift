//
//  Player.swift
//  Football Manager
//
//  Created by Stefan's FakeMac on 4/26/20.
//  Copyright © 2020 Stefan's FakeMacasasa. All rights reserved.
//

import Foundation

class Player: NSObject, NSCoding{
    var name: String = "";
    var role: String = "";
    var stamina: Int = 0;
    var rating: Int = 0;
    var redCard: Bool = false;
    var yellowCards: Int = 0;
    var hasYellowInGame: Bool = false
    var teamRole: TeamRoles = TeamRoles.Reserved;
    
    override init() {
    }
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.role = aDecoder.decodeObject(forKey: "role") as! String
        self.stamina = Int(aDecoder.decodeInt32(forKey: "stamina"))
        self.rating = Int(aDecoder.decodeInt32(forKey: "rating"))
        self.redCard = Bool(aDecoder.decodeBool(forKey: "redCard"))
        self.yellowCards = Int(aDecoder.decodeInt32(forKey: "yellowCards"))
        self.teamRole = TeamRoles(rawValue: aDecoder.decodeObject(forKey: "teamRole") as! String)!
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(role, forKey: "role")
        aCoder.encode(stamina, forKey: "stamina")
        aCoder.encode(rating, forKey: "rating")
        aCoder.encode(redCard, forKey: "redCard")
        aCoder.encode(yellowCards, forKey: "yellowCards")
        aCoder.encode(teamRole.rawValue, forKey: "teamRole")
    }
    
    func getRole() -> PlayerRole {
        if role.lowercased() == "gk" { return PlayerRole.GK}
        if role.lowercased() == "cb" { return PlayerRole.CB}
        if role.lowercased() == "cm" { return PlayerRole.CM}
        if role.lowercased() == "st" { return PlayerRole.ST}
        return PlayerRole.CM
    }
}

enum PlayerRole: String{
    case GK = "GK"
    case CB = "CB"
    case CM = "CM"
    case ST = "ST"
}
