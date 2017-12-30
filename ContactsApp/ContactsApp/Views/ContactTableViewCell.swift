//
//  ContactTableViewCell.swift
//  ContactsApp
//
//  Created by Ashis Laha on 30/12/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//

import UIKit

class ContactTableViewCell : UITableViewCell {
    
    // add a NSCache for caching the images
    let cacheImages = NSCache<NSString, UIImage>()
    
    // model
    public var model : Contact? {
        didSet {
            loaadImage(urlString: model?.profile_pic ?? "")
            
            let firstName = model?.first_name ?? ""
            let lastName = model?.last_name ?? ""
            name.text = firstName + " " + lastName
            
            if let isFavourite = model?.favorite {
                favouriteImageView.isHidden = !isFavourite
            }
        }
    }
    
    // profile image
    @IBOutlet private weak var profileImage: UIImageView! {
        didSet {
            profileImage.layer.cornerRadius = profileImage.frame.size.height/2
            profileImage.clipsToBounds = true
            profileImage.layer.borderWidth = 1
            profileImage.layer.borderColor = UIColor.black.cgColor
        }
    }
    
    // name
    @IBOutlet private weak var name: UILabel! {
        didSet {
            name.font = UIFont.boldSystemFont(ofSize: 14)
            name.textAlignment = .left
            name.textColor = .black
            name.numberOfLines = 1
            name.lineBreakMode = .byTruncatingTail
        }
    }

    // favourite Image
    @IBOutlet private weak var favouriteImageView: UIImageView!
    
    private func loaadImage(urlString : String) {
        guard let url = URL(string: urlString), urlString != "" else { return }
        // check whether the image is present into cache or not
        if let image = cacheImages.object(forKey: NSString(string: urlString)) {
            profileImage.image = image
            
        } else {
            let session = URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data , error == nil else { return }
                
                DispatchQueue.main.async { [weak self] in
                    guard let image = UIImage(data: data) else { return }
                    self?.cacheImages.setObject(image, forKey: NSString(string: urlString)) // setting into cache
                    self?.profileImage.image = image
                }
            }
            session.resume()
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

