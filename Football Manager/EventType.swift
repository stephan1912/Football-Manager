//
//  EventType.swift
//  Football Manager
//
//  Created by Stefan's FakeMac on 4/28/20.
//  Copyright © 2020 Stefan's FakeMacasasa. All rights reserved.
//

import Foundation

class GameEvent: NSObject, NSCoding{
    var Event: String = ""
    var Min: Int = 0
    init(event: String, min: Int){
        self.Min = min
        self.Event = event
    }
    
    func getEvent() -> String{
        return String(Min) + ". " + Event
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.Min = Int(aDecoder.decodeInt32(forKey: "min"))
        self.Event = aDecoder.decodeObject(forKey: "event") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(Min, forKey: "min")
        aCoder.encode(Event, forKey: "event")
    }
}

enum EventType: String{
    case Posesie = " are posesie"
    case Atac = " este in atac"
    case Start = " are lovitura de start"
    case Corner = " are lovitura de colt"
    case Gol = " a inscris un gol pentru "
    case Win = " a castigat partida"
    case CatonasG = " a primit cartonas galben"
    case CatonasR = " a primit cartonas rosu"
}
