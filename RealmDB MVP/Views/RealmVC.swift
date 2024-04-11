//
//  ReakmVC.swift
//  RealmDB MVP
//
//  Created by Alisher Tulembekov on 10.04.2024.
//

import UIKit
import RealmSwift
import SnapKit

protocol namesView {
    func getNames(_ names: Results<fullName>)
    func deleteNames(_ fullname: fullName)
    func editNames(name: String?, surname: String?, password: String?, at index: Int)
}

class RealmVc: UIViewController {
    
    let realm = try! Realm()
    
    var presentor: FullNamesPresentor?
    
    var fullnnames = [fullName]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    lazy var nameTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "insert name"
        return textfield
    }()
    
    lazy var surnameTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "insert surname"
        return textfield
    }()
    
    lazy var paswordTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "insert password"
        return textfield
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "some text"
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("tap me", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        //        tableView.separatorStyle = .none
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        presentor?.viewDidLoad()
    }
    
    private func setupViews() {
        view.addSubview(nameTextField)
        view.addSubview(surnameTextField)
        view.addSubview(paswordTextField)
        view.addSubview(label)
        view.addSubview(button)
        view.addSubview(tableView)
        view.backgroundColor = .white
        
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
        surnameTextField.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
        paswordTextField.snp.makeConstraints { make in
            make.top.equalTo(surnameTextField.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
        label.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(12)
            make.top.equalTo(paswordTextField.snp.bottom).offset(12)
            
        }
        
        button.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.centerX.equalToSuperview()
            make.top.equalTo(label.snp.bottom).offset(12)
            make.height.equalTo(40)
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(12)
            make.top.equalTo(button.snp.bottom).offset(12)
            make.bottom.equalToSuperview()
        }
    }
    @objc func buttonTapped() {
        let fullnames = fullName()
        
        fullnames.name = nameTextField.text ?? ""
        fullnames.surname = surnameTextField.text ?? ""
        fullnames.pasword = paswordTextField.text ?? ""
        
        nameTextField.text = ""
        surnameTextField.text = ""
        paswordTextField.text = ""
        
        presentor?.buttonTapped(fullnames)

    }
}
extension RealmVc: namesView {
    
    func deleteNames(_ fullname: fullName) {
        presentor?.deleteName(fullname)
    }
    
    
    func getNames(_ names: Results<fullName>) {
        self.fullnnames = Array(names)
        tableView.reloadData()
        
    }

    func editNames(name: String?, surname: String?, password: String?, at index: Int) {
        presentor?.updateNames(name: name, surname: surname, password: password, at : index)
    }
    
}

extension RealmVc: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fullnnames.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = fullnnames[indexPath.row].name + " " + fullnnames[indexPath.row].surname + " " + fullnnames[indexPath.row].pasword //я не знаю считается ли это за бизнес логику или нет. Но не охота отдельную функцию создавать в презентере ради этого
        return cell
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] (_, _, completionHandler) in
            self?.editName(at: indexPath)
            completionHandler(true)
        }
        editAction.backgroundColor = .blue
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
            self?.deleteName(at: indexPath)
            completionHandler(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
    private func editName(at indexPath: IndexPath) {
        editNames(name: nameTextField.text, surname: surnameTextField.text, password: paswordTextField.text, at: indexPath.row)
        nameTextField.text = ""
        paswordTextField.text = ""
        surnameTextField.text = ""
        presentor?.getNames()
        
    }
    
    private func deleteName(at indexPath: IndexPath) {
        let fullname = fullnnames[indexPath.row]
        deleteNames(fullname)
        presentor?.getNames()
    }
}
