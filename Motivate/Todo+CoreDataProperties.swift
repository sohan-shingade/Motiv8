//
//  Todo+CoreDataProperties.swift
//  Motivate
//
//  Created by Sohan Shingade on 4/13/20.
//  Copyright © 2020 Sohan Shingade. All rights reserved.
//
//

import Foundation
import CoreData


extension Todo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Todo> {
        return NSFetchRequest<Todo>(entityName: "TodoItem")
    }

    @NSManaged public var title: String?

}
