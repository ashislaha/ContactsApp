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
        phone_number = dict["phone_number"] as? String
        email = dict["email"] as? String
        created_at = dict["created_at"] as? String
        updated_at = dict["updated_at"] as? String
    }
}

// colletion view Cell type in contact details page
enum CellType : String {
    case message = "message"
    case call = "call"
    case email = "email"
    case favourite = "favourite"
}

// data request type
enum NetworkRequest : String {
    case GET = "get"
    case POST = "post"
    case PUT = "put"
    case DELETE = "delete"
}

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
        
        guard let url = URL(string: urlStr) else { return }
        let session = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else { return }
            
            if let _ = id { // getting one contact
                
                guard let contactDict = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : Any] else { return }
                if let contactDict = contactDict {
                     callback?([Contact(dict: contactDict)])
                }
            
            } else { // all contact
                
                guard let contactArray = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String : Any]] else { return }
                
                var contacts : [Contact] = []
                contactArray?.forEach { (dict) in
                    contacts.append(Contact(dict: dict))
                }
                callback?(contacts)
            }
        }
        session.resume()
    }
    
    // PUT / POST / DELETE
    class func updateContact(contact : Contact, requestType : NetworkRequest) {
        
        // update url based on "put" or "post"
        var urlString : String = ""
        if requestType == .PUT || requestType == .DELETE  { // put OR delete
            if let urlStr = contact.url {
                urlString = urlStr
            } else if let id = contact.id {
                urlString = Constants.putEndPoint + "\(id).json"
            }
        } else if requestType == .POST { // post
            urlString = Constants.contactEndPoint
        }
        
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
            
            if error == nil {
                if requestType == .POST {
                    print("Successfully done POST request")
                } else if requestType == .PUT {
                    print("Successfully done PUT request")
                } else if requestType == .DELETE {
                     print("Successfully DELETED")
                }
            }
        }
        session.resume()
    }
    
    private class func getDictionary(contact : Contact) -> [String : Any] {
        var dict : [String : Any] = [:]
        
        if let id = contact.id {
            dict["id"] = "\(id)"
        }
        if let firstName = contact.first_name {
            dict["first_name"] = firstName
        }
        if let lastName = contact.last_name {
            dict["last_name"] = lastName
        }
        if let picture = contact.profile_pic {
            dict["profile_pic"] = picture
        }
        if let email = contact.email {
            dict["email"] = email
        }
        if let phoneNumber = contact.phone_number {
            dict["phone_number"] = phoneNumber
        }
        if let favourite = contact.favorite {
            dict["favorite"] = favourite
        }
        return dict
    }
    
    private class func getJsonDataFromDictionary(jsonDict httpBody: [String: Any]?) -> Data? {
        var bodyData: Data? = nil
        if let httpBody = httpBody {
            bodyData = try? JSONSerialization.data(withJSONObject: httpBody, options: .prettyPrinted)
        }
        return bodyData
    }
}
