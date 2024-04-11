//
//  Fullnames.swift
//  RealmDB MVP
//
//  Created by Alisher Tulembekov on 10.04.2024.
//

import Foundation
import RealmSwift

class fullName: Object {
    @Persisted var name: String
    @Persisted var surname: String
    @Persisted var pasword: String

}
