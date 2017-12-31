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
    var image : Data?  // used for inside app only while data-flow happens
    
    init(dict : [String : Any]) {
        id = dict[Constants.id] as? Int
        profile_pic = dict[Constants.profilePic] as? String
        first_name = dict[Constants.firstName] as? String
        last_name = dict[Constants.lastName] as? String
        favorite = dict[Constants.favorite] as? Bool
        url = dict[Constants.url] as? String
        phone_number = dict[Constants.phoneNumber] as? String
        email = dict[Constants.email] as? String
        created_at = dict[Constants.createdAt] as? String
        updated_at = dict[Constants.updatedAt] as? String
        image = dict[Constants.imageData] as? Data
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
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
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
                    print("\n Response Dictionary :",responseJSON)
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
    
    private class func getDictionary(contact : Contact) -> [String : Any] {
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
    
    private class func getJsonDataFromDictionary(jsonDict httpBody: [String: Any]?) -> Data? {
        var bodyData: Data? = nil
        if let httpBody = httpBody {
            bodyData = try? JSONSerialization.data(withJSONObject: httpBody, options: .prettyPrinted)
        }
        return bodyData
    }
}
