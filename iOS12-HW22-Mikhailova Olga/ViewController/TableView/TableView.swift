//
//  TableView.swift
//  iOS12-HW22-Mikhailova Olga
//
//  Created by FoxxFire on 06.05.2024.
//

import UIKit

class TableView: UIView {
    
    weak var delegate: ViewController?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        tableView.layer.cornerRadius = 10
        tableView.backgroundColor = .systemGray6
        tableView.dataSource = delegate
        tableView.delegate = delegate
        return tableView
    }()
    
    init(delegate: ViewController) {
        super.init(frame: .zero)
        self.delegate = delegate
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadTable() {
        print(#function)
        tableView.reloadData()
    }
    
    func beginUpdates(){
        tableView.beginUpdates()
    }
    
    func endUpdates() {
        tableView.endUpdates()
    }
    
    func insert(indexPath: IndexPath){
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    func deleteRows(indexPath: IndexPath){
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    private func setupHierarchy() {
        addSubview(tableView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
        ])
    }
}



