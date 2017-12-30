//
//  ContactDetailCollectionViewCell.swift
//  ContactsApp
//
//  Created by Ashis Laha on 30/12/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//

import UIKit

struct ContactDetailCollectionViewCellModel {
    let cellType : CellType
    var isFavourite : Bool
}

class ContactDetailCollectionViewCell: UICollectionViewCell {
    
    var model : ContactDetailCollectionViewCellModel? {
        didSet {
            if let desc = model?.cellType.rawValue {
                label.text = desc
                if desc == "favourite" {
                    if let isFavourite = model?.isFavourite, isFavourite {
                        imageView.image = UIImage(named: "star")
                    } else {
                        imageView.image = UIImage(named: "favourite")
                    }
                } else {
                    imageView.image = UIImage(named: desc)
                }
            }
        }
    }
    
    var cellType : CellType? {
        didSet {
            
        }
    }
    
    private let imageView : UIImageView = { // closure
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false // enable autolayout
        imageView.contentMode = .scaleAspectFit
        return imageView
    }() // () is used to execute the closure
    
    private let label : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()
    
    //MARK:- Layout Setup
    private func layoutSetup() {
        
        NSLayoutConstraint.activate([
            // image layout
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -10), // shift a bit up from centerX
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            imageView.heightAnchor.constraint(equalToConstant: 50),
            imageView.widthAnchor.constraint(equalToConstant: 50),
            
            //label layout
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8)
        ])
    }
    
    private func viewSetup() {
        addSubview(imageView)
        addSubview(label)
        layoutSetup()
    }
    
    // view loading
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
