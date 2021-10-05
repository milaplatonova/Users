//
//  NetworkingManager.swift
//  Users
//
//  Created by Lyudmila Platonova on 12.08.21.
//

import Alamofire

class NetworkingManager {
    static let shared = NetworkingManager()
    
    var users: [User] = []
    func downloadUsers (usedUrl: String) {
        var downloadedUsers: [User] = []
        
        if let url = URL(string: usedUrl) {
            AF.request(url, method: .get, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
                if let data = response.data {
                    do {
                        let jsonObject = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                        print (jsonObject)
                        guard let json = jsonObject as? [String : Any] else { return }
                        
                        if let results = json["results"] as? [[String : Any]] {
                            print (results)
                            for newUser in results {
                                var user = User(title: "", name: "", surname: "", dob: "", street: "", building: "", postcode: "", city: "", state: "", country: "", phone: "", cell: "", email: "", thumbnailImage: "", mediumImage: "", largeImage: "")
                                if let fullNameDict = newUser["name"] as? [String : Any] {
                                    if let title = fullNameDict["title"] as? String, let name = fullNameDict["first"] as? String, let surname = fullNameDict["last"] as? String {
                                        user.title = title
                                        user.name = name
                                        user.surname = surname
                                        user.fullName = name + " " + surname
                                    }
                                }
                                if let dobDict = newUser["dob"] as? [String : Any] {
                                    if let dob = dobDict["date"] as? String {
                                        user.dob = dob
                                    }
                                }
                                if let locationDict = newUser["location"] as? [String : Any] {
                                    if let streetDict = locationDict["street"] as? [String : Any] {
                                        if let streetName = streetDict["name"] as? String, let streetNumb = streetDict["number"] as? Int {
                                            user.street = streetName
                                            user.building = String(streetNumb)
                                        }
                                    }
                                    if let city = locationDict["city"] as? String, let state = locationDict["state"] as? String, let country = locationDict["country"] as? String {
                                        user.city = city
                                        user.state = state
                                        user.country = country
                                    }
                                    if let postcode = locationDict["postcode"] as? String {
                                        user.postcode = postcode
                                    } else if let postcode = locationDict["postcode"] as? Int {
                                        user.postcode = String (postcode)
                                    }
                                }
                                if let phone = newUser["phone"] as? String, let cell = newUser["cell"] as? String, let email = newUser["email"] as? String {
                                    user.phone = phone
                                    user.cell = cell
                                    user.email = email
                                }
                                if let imageDict = newUser["picture"] as? [String : Any] {
                                    if let thumbnailImageUrl = imageDict["thumbnail"] as? String, let mediumImageUrl = imageDict["medium"] as? String, let largeImageUrl = imageDict["large"] as? String {
                                        user.thumbnailImage = thumbnailImageUrl
                                        user.mediumImage = mediumImageUrl
                                        user.largeImage = largeImageUrl
                                    }
                                }
                                downloadedUsers.append(user)
                            }
                            Singleton.instance.users = downloadedUsers
                        }
                    } catch (let exception) {
                        print (exception)
                    }
                }
            }
        }
    }
    
}
