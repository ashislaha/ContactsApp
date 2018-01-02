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
