//
//  User.swift
//  Users
//
//  Created by Lyudmila Platonova on 16.06.21.
//

import Foundation

struct User: Comparable {
    
    public var title: String
    public var name: String
    public var surname: String
    public var fullName: String
    public var dob: String
    public var street: String
    public var building: String
    public var postcode: String
    public var city: String
    public var state: String
    public var country: String
    public var phone: String
    public var cell: String
    public var email: String
    public var thumbnailImage: String
    public var mediumImage: String
    public var largeImage: String
    
    init (title: String, name: String, surname: String, dob: String, street: String, building: String, postcode: String, city: String, state: String, country: String, phone: String, cell: String, email: String, thumbnailImage: String, mediumImage: String, largeImage: String) {
        self.title = title
        self.name = name
        self.surname = surname
        self.fullName = name + " " + surname
        self.dob = dob
        self.street = street
        self.building = building
        self.postcode = postcode
        self.city = city
        self.state = state
        self.country = country
        self.phone = phone
        self.cell = cell
        self.email = email
        self.thumbnailImage = thumbnailImage
        self.mediumImage = mediumImage
        self.largeImage = largeImage
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.fullName == rhs.fullName
    }
    
    static func < (lhs: User, rhs: User) -> Bool {
        return lhs.fullName < rhs.fullName
    }
    
}
