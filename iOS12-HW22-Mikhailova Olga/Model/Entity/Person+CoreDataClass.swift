//
//  Person+CoreDataClass.swift
//  iOS12-HW22-Mikhailova Olga
//
//  Created by FoxxFire on 06.05.2024.
//
//

import Foundation
import CoreData

@objc(Person)
public class Person: NSManagedObject {
  
    // для создания объекта
    convenience init() {
        self.init(entity: managerCoreData.entityForName(entityName: Constants.entity.rawValue), insertInto: managerCoreData.context)
    }
}

extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: Constants.entity.rawValue)
    }

    @NSManaged public var name: String?
    @NSManaged public var photo: Data?
    @NSManaged public var birthdayDate: Date?
    @NSManaged public var gender: String?

}

extension Person : Identifiable {

}
