//
//  TableViewCell.swift
//  iOS12-HW22-Mikhailova Olga
//
//  Created by FoxxFire on 06.05.2024.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    static let identifier = "TableViewCell"
    
    private lazy var name: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "palatino", size: 20)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupHierarchy() {
        contentView.addSubview(name)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            name.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            name.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            name.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            name.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 10)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.accessoryType = .none
    }
}
