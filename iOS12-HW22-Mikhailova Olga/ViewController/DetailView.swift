//
//  DetailView.swift
//  iOS12-HW22-Mikhailova Olga
//
//  Created by FoxxFire on 06.05.2024.
//

import UIKit
import CoreData

class DetailView: UIViewController{
    
    var presenter: DetailViewProtocol?
    var isEdit = false
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private lazy var photo: UIImageView = {
        let image = UIImage()
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 140
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var name: UITextField = {
        let textField = UITextField()
        textField.font = UIFont(name: "palatino", size: 18)
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.setupLeftImage(imageName: "person.and.background.striped.horizontal")
        textField.underline(borderColor: .red)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
 
    private lazy var birthday: UITextField = {
        let textField = UITextField()
        textField.font = UIFont(name: "palatino", size: 18)
        textField.textColor = .black
        textField.backgroundColor = .white
        textField.setupLeftImage(imageName: "calendar")
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var gender: UITextField = {
        let textField = UITextField()
        textField.font = UIFont(name: "palatino", size: 18)
        textField.textColor = .black
        textField.backgroundColor = .white
        textField.setupLeftImage(imageName: "figure.dress.line.vertical.figure")
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var other: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Other", for: .normal)
        button.addTarget(self, action: #selector(otherTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupHierarchy()
        setupLayout()
        setupNavigationBar()
        contentIsEdit(isEdit: isEdit)
        setup()
        guesture()
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
    
    override func viewDidLayoutSubviews() {
           
        let lineColor = UIColor.lightGray
        [name, birthday, gender].forEach{ text in
            text.underline(borderColor: lineColor)}
       }
    
    func setup() {
        guard let value = presenter?.saved() else { return }
        name.text = value.name
        gender.text = value.gender
        birthday.text = value.birthdayDate?.string()
        if let dataPhoto = value.photo {
            if let image = UIImage(data: dataPhoto) {
                photo.image = image
            }
        } else {
            presenter?.takePhoto(closure: { data in
                guard let data else { self.photo.image = UIImage(named: "smth"); return }
                self.photo.image = UIImage(data: data)
            })
        }
    }
    
    func contentIsEdit(isEdit: Bool){
        name.isUserInteractionEnabled = isEdit
        birthday.isUserInteractionEnabled = isEdit
        gender.isUserInteractionEnabled = isEdit
        other.isUserInteractionEnabled = isEdit
    }
    
    private func setupHierarchy() {
        [ scrollView, photo ,name, birthday, gender, other].forEach {view.addSubview($0)}
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            photo.heightAnchor.constraint(equalToConstant: 280),
            photo.widthAnchor.constraint(equalToConstant: 280),
            photo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            photo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            name.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            name.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            name.topAnchor.constraint(equalTo: photo.bottomAnchor, constant: 45),
            name.bottomAnchor.constraint(equalTo: name.topAnchor, constant: 30),

            birthday.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            birthday.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 20),
            birthday.trailingAnchor.constraint(equalTo: name.trailingAnchor),
            birthday.bottomAnchor.constraint(equalTo: birthday.topAnchor, constant: 30),
            
            gender.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            gender.topAnchor.constraint(equalTo: birthday.bottomAnchor, constant: 20),
            gender.trailingAnchor.constraint(equalTo: name.trailingAnchor),
            gender.bottomAnchor.constraint(equalTo: gender.topAnchor, constant: 30),
            
            other.trailingAnchor.constraint(equalTo: gender.trailingAnchor, constant: -20),
            other.topAnchor.constraint(equalTo: gender.topAnchor),
            other.bottomAnchor.constraint(equalTo: gender.bottomAnchor)
        ])
    }
    
    @objc private func otherTapped() {
        let alert = UIAlertController(title: "No worries", message: "You can decide later", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        present(alert, animated: true, completion:  nil)
    }
}

extension DetailView {
    private func setupNavigationBar() {
        let customView = UIButton(frame: CGRect(x: 0, y: 0, width: 75, height: 20))
        customView.setTitle(isEdit ? "Save" : "Edit", for: .normal)
        customView.setTitleColor(.green, for: .focused)  // почему
        customView.backgroundColor = .orange
        customView.layer.cornerRadius = 8
        customView.layer.masksToBounds = true
        customView.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            customView: customView
        )
    }
    
    @objc func buttonTapped(sender: UIButton) {
        if isEdit {
            // save
            guard let person = presenter?.saved() else { return }
            person.photo = photo.image?.pngData()
            person.name = name.text ?? ""
            person.birthdayDate? = birthday.text?.date() ?? Date.now
            CoreDataManager.shared.saveContext()
            if gender.text == "Man" || gender.text == "Woman" {
                person.gender = gender.text
                CoreDataManager.shared.saveContext()
            } else {
                otherTapped()
            }
        }
        isEdit.toggle()
        sender.setTitle(isEdit ? "Save" : "Edit", for: .normal)
        contentIsEdit(isEdit: isEdit)
    }
}

