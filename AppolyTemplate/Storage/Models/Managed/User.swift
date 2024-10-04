//
//  User.swift
//  AppolyTemplate
//
//  Created by James Wolfe on 08/03/2021.
//  Copyright © 2021 Appoly. All rights reserved.
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject {

    // MARK: - Variables
    @nonobjc
    class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var id: Int64
    @NSManaged public var email: String

    // MARK: - Initializers
    init(response: UserResponse, insertInto context: NSManagedObjectContext) {
        super.init(entity: NSEntityDescription.entity(forEntityName: "User", in: context)!, insertInto: context)
        self.email = response.email
        self.id = id
    }

}
