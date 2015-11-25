//
//  Item+CoreDataProperties.swift
//  Isaac Items
//
//  Created by Philipp Baum on 07/11/15.
//  Copyright © 2015 Thinkcoding. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Item {

    @NSManaged var effect: String?
    @NSManaged var foundin: String?
    @NSManaged var imagename: String?
    @NSManaged var name: String?
    @NSManaged var notes: String?
    @NSManaged var pickupquote: String?
    @NSManaged var rechargetime: Int16
    @NSManaged var type: String?
    @NSManaged var propertys: String?

}
