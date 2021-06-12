//
//  User.swift
//  Football Manager
//
//  Created by user196359 on 6/12/21.
//  Copyright © 2021 Stefan's FakeMacasasa. All rights reserved.
//

import Foundation
import CoreData

@objc(User)
class DBUser: NSManagedObject {
    @NSManaged var username: String!
    @NSManaged var email: String!
    @NSManaged var password: String!
    @NSManaged var clubleague: String!
    @NSManaged var clubname: String!
    @NSManaged var scoreboard: String!
}
