//
//  Contants.swift
//  ContactsApp
//
//  Created by Ashis Laha on 30/12/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    
    static let contactCellId        = "contactCell"
    static let headerID             = "headerID"
    static let detailCell           = "detailCell"
    static let editCell             = "editCell"
    static let collectionViewCell   = "collectionViewCell"
    
    static let greenyColor          = UIColor(red: 86/255.0, green: 223/255.0, blue: 196/255.0, alpha: 1.0)
    
    static let contactEndPoint      = "http://gojek-contacts-app.herokuapp.com/contacts.json" // used for GET and POST
    static let putEndPoint          = "http://gojek-contacts-app.herokuapp.com/contacts/" // 12.json // for PUT and DELETE
    
    
    static let id           = "id"
    static let profilePic   = "profile_pic"
    static let firstName    = "first_name"
    static let lastName     = "last_name"
    static let favorite     = "favorite"
    static let url          = "url"
    static let phoneNumber  = "phone_number"
    static let email        = "email"
    static let createdAt    = "created_at"
    static let updatedAt    = "updated_at"
    static let imageData    = "image_data"
    
}


