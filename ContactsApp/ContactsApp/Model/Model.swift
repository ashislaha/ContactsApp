//
//  Model.swift
//  ContactsApp
//
//  Created by Ashis Laha on 30/12/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//

import Foundation

// Contact
struct Contact {
    var id : Int?
    var profile_pic : String?
    var first_name : String?
    var last_name : String?
    var email : String?
    var phone_number : String?
    var created_at : String?
    var updated_at : String?
    var favorite : Bool?
    var url : String?
    
    init(dict : [String : Any]) {
        id = dict["id"] as? Int
        profile_pic = dict["profile_pic"] as? String
        first_name = dict["first_name"] as? String
        last_name = dict["last_name"] as? String
        favorite = dict["favorite"] as? Bool
        url = dict["url"] as? String
    }
}

// colletion view Cell type in contact details page
enum CellType : String {
    case message = "message"
    case call = "call"
    case email = "email"
    case favourite = "favourite"
}


// Data Parser
class Parser {
    
    class func parseContacts(callback : (([Contact])->())? ) {
        
        guard let url = URL(string: Constants.contactEndPoint) else { return }
        let session = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else { return }
            guard let contactArray = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String : Any]] else { return }
            
            var contacts : [Contact] = []
            contactArray?.forEach { (dict) in
                contacts.append(Contact(dict: dict))
            }
            print(contacts)
            callback?(contacts)
        }
        session.resume()
    }
    
    class func postContact(contact : Contact) {
        
        guard let urlString = contact.url, let url = URL(string: urlString) else { return }
        let urlRequest = URLRequest(url: url)
        let data = Data()
        
        let session = URLSession.shared.uploadTask(with: urlRequest, from: data) { (data, response, error) in
            
        }
    }
}
