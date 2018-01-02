//
//  NetworkLayer.swift
//  ContactsApp
//
//  Created by Ashis Laha on 02/01/18.
//  Copyright © 2018 Ashis Laha. All rights reserved.
//

import Foundation

// Data Parser
class Parser {
    
    // GET
    class func getContacts(id : String? = nil, callback : (([Contact])->())?) {
        
        var urlStr : String = ""
        if let id = id {
            urlStr = Constants.putEndPoint + "\(id).json"
        } else {
            urlStr = Constants.contactEndPoint
        }
        
        print("\nGET URL : \(urlStr)")
        guard let url = URL(string: urlStr) else { return }
        let session = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else { return }
            
            if let _ = id { // getting one contact
                
                guard let contactDict = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : Any] else { return }
                if let contactDict = contactDict {
                    print("Successfully GET single contact")
                    callback?([Contact(dict: contactDict)])
                }
                
            } else { // all contact
                
                guard let contactArray = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String : Any]] else { return }
                
                var contacts : [Contact] = []
                contactArray?.forEach { (dict) in
                    contacts.append(Contact(dict: dict))
                }
                print("Successfully GET contacts list")
                callback?(contacts)
            }
        }
        session.resume()
    }
    
    // PUT / POST / DELETE
    class func updateContact(contact : Contact, requestType : NetworkRequest, completionHandler : ((Any?)->())? = nil) {
        
        // update url based on "PUT" or "POST"
        var urlString : String = ""
        if requestType == .PUT || requestType == .DELETE  { // PUT / DELETE
            if let urlStr = contact.url {
                urlString = urlStr
            } else if let id = contact.id {
                urlString = Constants.putEndPoint + "\(id).json"
            }
        } else if requestType == .POST { // POST
            urlString = Constants.contactEndPoint
        }
        
        print("\n\(requestType.rawValue) URL : \(urlString)")
        
        // validation
        guard let url = URL(string: urlString), !urlString.isEmpty else { return }
        
        // request
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = requestType.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // body
        let dict = requestType == .DELETE ? [:] : getDictionary(contact: contact)
        
        guard let data = getJsonDataFromDictionary(jsonDict: dict) else { return }
        
        // session
        let session = URLSession.shared.uploadTask(with: urlRequest, from: data) { (data, response, error) in
            
            if let data = data, error == nil {
                
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    print("\nResponse Dictionary :",responseJSON)
                }
                
                if requestType == .POST {
                    print("Successfully done POST request")
                } else if requestType == .PUT {
                    print("Successfully done PUT request")
                } else if requestType == .DELETE {
                    print("Successfully DELETED")
                }
                DispatchQueue.main.async {
                    completionHandler?(responseJSON)
                }
            }
        }
        session.resume()
    }
    
    // get groups from contacts
    class func getGroupContacts(contacts : [Contact]) -> [String : [Contact]] {
        
        var groupContacts : [String : [Contact]] = [:]
        
        // insert based on "favourite"
        let favourites = contacts.filter { (contact) -> Bool in
            if let isFavourite = contact.favorite, isFavourite {
                return true
            }
            return false
        }
        groupContacts["Fav"] = favourites
        
        // insert based on "first_name"
        for i in 1...26 {
            
            let alpahbeticContacts = contacts.filter({ (contact) -> Bool in
                
                // do not consider favourite again
                if let isFavourite = contact.favorite, isFavourite {
                    return false
                }
                // check 1st char of first_name
                if let firstName = contact.first_name?.uppercased(), firstName.hasPrefix(Constants.alphabet[i]) {
                    return true
                }
                return false
            })
            groupContacts[Constants.alphabet[i]] = alpahbeticContacts
        }
        return groupContacts
    }
}

//MARK: Private extension
private extension Parser {
    
    class func getDictionary(contact : Contact) -> [String : Any] {
        var dict : [String : Any] = [:]
        
        if let firstName = contact.first_name {
            dict[Constants.firstName] = firstName
        }
        if let lastName = contact.last_name {
            dict[Constants.lastName] = lastName
        }
        if let picture = contact.profile_pic {
            dict[Constants.profilePic] = picture
        }
        if let email = contact.email {
            dict[Constants.email] = email
        }
        if let phoneNumber = contact.phone_number {
            dict[Constants.phoneNumber] = phoneNumber
        }
        if let favourite = contact.favorite {
            dict[Constants.favorite] = favourite
        }
        if let createdAt = contact.created_at {
            dict[Constants.createdAt] = createdAt
        }
        if let updateAt = contact.updated_at {
            dict[Constants.updatedAt] = updateAt
        }
        return dict
    }
    
    class func getJsonDataFromDictionary(jsonDict httpBody: [String: Any]?) -> Data? {
        var bodyData: Data? = nil
        if let httpBody = httpBody {
            bodyData = try? JSONSerialization.data(withJSONObject: httpBody, options: .prettyPrinted)
        }
        return bodyData
    }
}
