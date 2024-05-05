//
//  Person+CoreDataProperties.swift
//  iOS12-HW22-Mikhailova Olga
//
//  Created by FoxxFire on 06.05.2024.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var birthdayDate: Date?
    @NSManaged public var gender: String?
    @NSManaged public var name: String?
    @NSManaged public var photo: Data?

}

extension Person : Identifiable {

}
