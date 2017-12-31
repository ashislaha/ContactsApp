//
//  EditTableViewCell.swift
//  ContactsApp
//
//  Created by Ashis Laha on 31/12/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//

import UIKit

protocol EditCellDelegate : class {
    func getIndex(val : Int)
    func getValue(text : String?, index : Int)
}

class EditTableViewCell: UITableViewCell {

    public weak var delegate : EditCellDelegate?
    
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
    
    @IBOutlet  weak var value: UITextField! {
        didSet {
            value.delegate = self
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension EditTableViewCell : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        delegate?.getValue(text: textField.text, index: textField.tag)
        return false
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("Text Field tapped : Row(\(textField.tag))")
        delegate?.getIndex(val: textField.tag)
        return true
    }
}
