//
//  ViewController.swift
//  iOS12-HW22-Mikhailova Olga
//
//  Created by FoxxFire on 06.05.2024.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var presenter: PresenterProtocol?
    
    private lazy var textField: UITextField = {
        let text = UITextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.placeholder = "name surname"
        text.layer.borderWidth = 2
        text.layer.borderColor = UIColor.white.cgColor
        text.layer.cornerRadius = 8
        text.textAlignment = .center
        text.backgroundColor = .white
        return text
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemOrange
        button.setTitle("Add person", for: .normal)
        button.setTitleColor(.orange, for: .focused)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttontap), for: .touchUpInside)
        return button
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private lazy var tableView: TableView = {
        let view = TableView(delegate: self)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray2
        presenter?.fetchResultController.delegate = self
        
        setupView()
        setupHierarchy()
        setupLayout()
        guesture()
        
        // выборка данных из базы
        do {
            try presenter?.performFetch()
        } catch {
            print(error)
        }
    }
    
    func guesture() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.touch))
        recognizer.numberOfTapsRequired = 1
        recognizer.numberOfTouchesRequired = 1
        scrollView.addGestureRecognizer(recognizer)
    }
    
    @objc func touch() {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadTable()
    }
    
    @objc func buttontap() -> Bool {
        
        if textField.text!.isEmpty {
            let alert = UIAlertController(title: "Warning!", message: "Text field can't be empty", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
            present(alert, animated: true, completion:  nil)
            return false
        }
        
        presenter?.createNewObject(text: textField.text, picture: nil, gender: nil)
        self.view.endEditing(true)
        textField.text = nil
        self.tableView.reloadTable()
        
        return true
    }
    
    private func setupView() {
        setupHierarchy()
        setupLayout()
    }
    
    private func setupHierarchy() {
        [scrollView, textField, button, tableView].forEach{view.addSubview($0)}
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            textField.heightAnchor.constraint(equalToConstant: 40),
            
            button.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 15),
            button.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            button.heightAnchor.constraint(equalToConstant: 40),
            
            tableView.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 25),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
        ])
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell else { return UITableViewCell() }
        var config = UIListContentConfiguration.cell()
        let person = presenter?.getPerson(index: indexPath)
        config.text = person?.name
        cell.contentConfiguration = config
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = presenter?.getSection() {
            print(sections[section].numberOfObjects)
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = DetailView()
        tableView.deselectRow(at: indexPath, animated: true)
        let _ = presenter?.getPerson(index: indexPath)
        viewController.presenter = presenter
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let person = presenter?.getPerson(index: indexPath) {
                presenter?.delete(person: person)
            }
        }
    }
}

extension ViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print(#function)
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print(#function)
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insert(indexPath: indexPath)
            }
        case .update:
            if let indexPath = indexPath {
                _ = presenter?.getPerson(index: indexPath)
            }
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(indexPath: indexPath)
            }
            if let indexPath = newIndexPath {
                tableView.insert(indexPath: indexPath)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(indexPath: indexPath)
            }
        default:
            break
        }
    }
}

extension ViewController: ViewAppearance { }
