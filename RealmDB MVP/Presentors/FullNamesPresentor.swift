//
//  ViewController.swift
//  RealmDB MVP
//
//  Created by Alisher Tulembekov on 10.04.2024.
//

import UIKit
import RealmSwift

protocol FullNamesPresentorLogin {
    func viewDidLoad()
    func buttonTapped(_ fullnames: fullName)
    func getNames()
    func deleteName(_ fullname: fullName)
    func updateNames(name: String?, surname: String?, password: String?, at index: Int?)
}

class FullNamesPresentor {
    
    var view: namesView?
    
    let realm = try! Realm()
    
    func viewDidLoad() {
        getNames()
    }
    
    func getNames() {
        let fullnames = realm.objects(fullName.self)
        view?.getNames(fullnames)
    }
    
    func buttonTapped(_ fullnames: fullName) {
        try! realm.write {
            realm.add(fullnames)
        }
//        print ("asdasd") тестил 
        getNames()
    }
    func deleteName(_ fullname: fullName) {
        try! realm.write {
            realm.delete(fullname)
        }
    }
    func updateNames(name: String?, surname: String?, password: String?, at index: Int){
        let country = realm.objects(fullName.self)[index]
        
        try! realm.write({
            if let name = name, !name.isEmpty {
                country.name = name
            }
            if let surname = surname, !surname.isEmpty {
                country.surname = surname
            }
            if let password = password, !password.isEmpty {
                country.pasword = password
            }
        })
    }

    
}

