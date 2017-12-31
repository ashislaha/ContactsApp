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
    static let all                  = "All"
    
    static let greenyColor          = UIColor(red: 86/255.0, green: 223/255.0, blue: 196/255.0, alpha: 1.0)
    
    static let contactEndPoint      = "http://gojek-contacts-app.herokuapp.com/contacts.json" // used for GET and POST
    static let putEndPoint          = "http://gojek-contacts-app.herokuapp.com/contacts/" // 12.json // for PUT and DELETE
    static let alphabet = ["Fav", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
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

//MARK: Get Greeny Gradient effect
extension CAGradientLayer {
    func getGradientEffect(frame : CGRect) {
        self.frame = frame
        self.colors = [UIColor(white: 1.0, alpha: 0.2).cgColor, UIColor(white: 1.0, alpha: 0.1).cgColor, Constants.greenyColor.withAlphaComponent(0.5).cgColor]
        self.locations = [0.0, 0.01, 1.0]
    }
}

//MARK: Error Handling Alert
extension UIViewController {
    
    func showAlert(header : String? = "Header", message : String? = "Message")  {
        let alertController = UIAlertController(title: header, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (alert) in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
