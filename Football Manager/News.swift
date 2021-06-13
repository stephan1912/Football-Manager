//
//  News.swift
//  Football Manager
//
//  Created by user196359 on 6/13/21.
//  Copyright © 2021 Stefan's FakeMacasasa. All rights reserved.
//

import Foundation

class News: Codable{
    var link: String
    var title: String
    
    enum CodingKeys: String, CodingKey {
        case link
        case title
    }
}
