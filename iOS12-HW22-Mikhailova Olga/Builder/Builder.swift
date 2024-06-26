//
//  Builder.swift
//  iOS12-HW22-Mikhailova Olga
//
//  Created by FoxxFire on 06.05.2024.
//

import UIKit

class Builder {
    static func module() -> UIViewController {
        let view = ViewController()
        let manager = CoreDataManager.shared
        let model = Person()
        let presenter = Presenter(view: view, manager: manager, model: model)
        view.presenter = presenter

        return view
    }
}
