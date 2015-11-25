//
//  Tracker+CoreDataProperties.swift
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

extension Tracker {

    @NSManaged var name: String?
    @NSManaged var seed: String?
    @NSManaged var active: Bool
    @NSManaged var items: TrackerItems?

}
