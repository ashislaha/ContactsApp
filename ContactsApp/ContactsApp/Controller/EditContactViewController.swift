//
//  EditContactViewController.swift
//  ContactsApp
//
//  Created by Ashis Laha on 30/12/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//

import UIKit

class EditContactViewController: UIViewController {

    public var model : Contact?
    
    //MARK: Outlets
    
    @IBOutlet private weak var topView: UIView!
    
    @IBOutlet private weak var imageView: UIImageView!
    
    
    
    //MARK: IBActions
    @IBAction private func cancelTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func doneTapped(_ sender: UIButton) {
        
        dismiss(animated: true) {
            // call some delegate to get the updates in Details page 
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
