//
//  HeaderView.swift
//  ContactsApp
//
//  Created by Ashis Laha on 30/12/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//

import UIKit

class ContactHeaderView : UITableViewHeaderFooterView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .blue
    }
    
    public var title : String? {
        didSet {
            headerLabel.text = title ?? ""
        }
    }
    
    private let headerLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.backgroundColor = .clear
        return label
    }()
    
    func viewSetup() {
        addSubview(headerLabel)
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: topAnchor),
            headerLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            headerLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0)
            ])
    }
}

