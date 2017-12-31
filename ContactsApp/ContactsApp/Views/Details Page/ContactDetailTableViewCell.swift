//
//  EditTableViewCell.swift
//  ContactsApp
//
//  Created by Ashis Laha on 30/12/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//

import UIKit

struct DetailsTableViewCellModel {
    var name : String
    var value : String
}

class ContactDetailTableViewCell : UITableViewCell {
    
    // model
    public var model : DetailsTableViewCellModel? {
        didSet {
            name.text = model?.name ?? ""
            value.text = model?.value ?? ""
        }
    }
    
    // name
    @IBOutlet private weak var name: UILabel! {
        didSet {
            name.font = UIFont.boldSystemFont(ofSize: 15)
            name.textAlignment = .right
            name.textColor = .lightGray
            name.numberOfLines = 1
            name.lineBreakMode = .byTruncatingTail
        }
    }
    
    // value
    @IBOutlet private weak var value: UILabel! {
        didSet {
            value.font = UIFont.boldSystemFont(ofSize: 15)
            value.textAlignment = .left
            value.textColor = .black
            value.numberOfLines = 1
            value.lineBreakMode = .byTruncatingTail
        }
    }
    
    // view loading
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        viewSetup()
    }
    private func viewSetup() {
        // can do other set up here if you want.
    }
}

