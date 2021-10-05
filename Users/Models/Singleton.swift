//
//  Singleton.swift
//  Users
//
//  Created by Lyudmila Platonova on 17.08.21.
//

import Foundation

class Singleton {
    
    //creates the instance and guarantees that it's unique
    static let instance = Singleton()
    private init() {
    }
    
    //creates the global variable
    var users: [User] = []
}
