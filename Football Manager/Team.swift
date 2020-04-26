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
}
