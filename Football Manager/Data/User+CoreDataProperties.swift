//
//  User+CoreDataProperties.swift
//  Football Manager
//
//  Created by user196359 on 6/12/21.
//  Copyright © 2021 Stefan's FakeMacasasa. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var username: String?
    @NSManaged public var email: String?
    @NSManaged public var password: String?
    @NSManaged public var clubleague: String?
    @NSManaged public var clubname: String?
    @NSManaged public var scoreboard: String?

}
