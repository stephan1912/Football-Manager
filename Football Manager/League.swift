//
//  League.swift
//  Football Manager
//
//  Created by Stefan's FakeMac on 4/26/20.
//  Copyright © 2020 Stefan's FakeMacasasa. All rights reserved.
//

import Foundation

class League: Codable{
    var name: String = "";
    var Teams: [Team] = [];
    
    /*
    override init(){
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        //self.Teams = aDecoder.decodeObject(forKey: "teams") as! [Team]
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(Teams, forKey: "teams")
    }*/
    
    enum CodingKeys: String, CodingKey {
        case name = "leagueName"
        case Teams = "teams"
    }
}
