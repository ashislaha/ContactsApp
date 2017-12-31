//
//  EditTableViewCell.swift
//  ContactsApp
//
//  Created by Ashis Laha on 31/12/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//

import UIKit

class EditTableViewCell: UITableViewCell {

    public var model : DetailsTableViewCellModel? {
        didSet {
            name.text = model?.name ?? ""
            value.text = model?.value ?? ""
        }
    }
    
    @IBOutlet weak var name: UILabel! {
        didSet {
            name.font = UIFont.boldSystemFont(ofSize: 15)
            name.textAlignment = .right
            name.textColor = .lightGray
            name.numberOfLines = 1
            name.lineBreakMode = .byTruncatingTail
        }
    }
    
    @IBOutlet  weak var value: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
