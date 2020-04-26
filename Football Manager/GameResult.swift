//
//  GameResult.swift
//  Football Manager
//
//  Created by Stefan's FakeMac on 4/26/20.
//  Copyright © 2020 Stefan's FakeMacasasa. All rights reserved.
//

import Foundation

class GameResult{
    
    var winningTeam: Team = Team()
    var losingTeam: Team = Team()
    var homeScore: Int = 0
    var awayScore: Int = 0
    var events: [String] = []
}
