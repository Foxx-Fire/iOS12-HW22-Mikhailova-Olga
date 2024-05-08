//
//  CoreDataManager.swift
//  iOS12-HW22-Mikhailova Olga
//
//  Created by FoxxFire on 06.05.2024.
//

import Foundation
import CoreData

enum Constants: String {
    case entity = "Person"
    case sortKey = "name"
}

//MARK:  CoreDataManager

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    var savedEntities = [Person]()
   // private init() { }
    
    // создаем контекст
     lazy var context: NSManagedObjectContext = {
        persistentContainer.viewContext
    }()
    
    
    // описываем сущность с которой будем работать
    func entityForName(entityName: String) -> NSEntityDescription {
        let i = entityName
        if i.isEmpty {
            return NSEntityDescription.entity(forEntityName: "Person", in: context) ?? NSEntityDescription()
        } else {
            return NSEntityDescription.entity(forEntityName: Constants.entity.rawValue, in: context) ?? NSEntityDescription()
        }
    }
    
    // MARK: Core Data stack
    // контейнер
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "iOS12_HW22_Mikhailova_Olga")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func fetchResultController(entityName: String, sortKey: String) -> NSFetchedResultsController<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let sortDescriptor = NSSortDescriptor(key: sortKey, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        return fetchResultController
    }
    
    // добавляем персон
    func addPerson(name: String?, surname: String?, birthdayDate: Date?, photo: Data?, gender: String?) {
        let newPerson = Person(context: persistentContainer.viewContext)
        newPerson.name = name
        newPerson.birthdayDate = birthdayDate
        newPerson.photo = photo
        newPerson.gender = gender
        saveContext()
    }
    
    // MARK: Core Data Saving support
    // сохраняем
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}




