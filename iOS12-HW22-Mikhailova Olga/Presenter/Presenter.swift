//
//  Presenter.swift
//  iOS12-HW22-Mikhailova Olga
//
//  Created by FoxxFire on 06.05.2024.
//

import Foundation
import CoreData

protocol ViewAppearance: AnyObject { }

protocol DetailViewProtocol: AnyObject {
    func saved() -> Person?
    func takePhoto(closure: @escaping (Data?) -> Void)
}

protocol PresenterProtocol: AnyObject, DetailViewProtocol {
    var fetchResultController: NSFetchedResultsController<NSFetchRequestResult> { get }
    init(view: ViewAppearance, manager: CoreDataManager, model: Person)
    func createNewObject(text: String?, picture: Data?, gender: String?)
    func getPerson(index: IndexPath) -> Person?
    func getSection() -> [NSFetchedResultsSectionInfo]?
    func delete(person: Person)
    func performFetch() throws
}

final class Presenter: PresenterProtocol {
    
    weak var view: ViewAppearance?
    private var manager: CoreDataManager?
    private var model: Person?
    
    var fetchResultController: NSFetchedResultsController<NSFetchRequestResult>
    
    init(view: ViewAppearance, manager: CoreDataManager, model: Person) {
        self.view = view
        self.manager = manager
        self.model = model
        fetchResultController = CoreDataManager.shared.fetchResultController(entityName: Constants.entity.rawValue, sortKey: Constants.sortKey.rawValue)
    }
    
    func createNewObject(text: String?, picture: Data?, gender: String?) {
        let managedObject = Person()
        managedObject.name = text
        managedObject.birthdayDate = Date()
        managedObject.photo = picture
        managedObject.gender = gender
        manager?.saveContext()
    }
    
    func getPerson(index: IndexPath) -> Person? {
        let modelAtIndexPath = fetchResultController.object(at: index) as? Person
        model = modelAtIndexPath
        return model
    }
    
    func getSection() -> [NSFetchedResultsSectionInfo]? {
        fetchResultController.sections
    }
    
    func delete(person: Person) {
        manager?.context.delete(person)
        manager?.saveContext()
    }
    
    func performFetch() throws {
        try fetchResultController.performFetch()
    }
}

extension Presenter: DetailViewProtocol {
    
    func saved() -> Person? {
        return model
    }
    
    func takePhoto(closure: @escaping (Data?) -> Void) {
        let api = "https://thispersondoesnotexist.com/"
        guard let apiURL = URL(string: api) else { closure(nil); return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: apiURL) { data, reponse, error in
            guard let data = data, error == nil else { closure(data); return }
            DispatchQueue.main.async {
                closure(data)
            }
        }
        task.resume()
    }
}
