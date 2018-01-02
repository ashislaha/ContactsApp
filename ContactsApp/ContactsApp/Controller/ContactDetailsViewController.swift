//
//  EditScreenViewController.swift
//  ContactsApp
//
//  Created by Ashis Laha on 30/12/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//

import UIKit

class ContactDetailsViewController: UIViewController {

    public var contactModel : Contact?
    
    var detailCellModel : [DetailsTableViewCellModel] = []
    var collectionCellModel : [ContactDetailCollectionViewCellModel] = []
    private var gradientLayer = CAGradientLayer()
    
    //MARK: Outlets
    @IBOutlet private weak var topView: UIView!
    
    @IBOutlet private weak var profileImageView: UIImageView! {
        didSet {
            profileImageView.layer.cornerRadius = profileImageView.frame.size.height/2
            profileImageView.clipsToBounds = true
            profileImageView.layer.borderWidth = 3
            profileImageView.layer.borderColor = UIColor.green.cgColor
        }
    }
    
    @IBOutlet private weak var name: UILabel! {
        didSet {
            name.font = UIFont.boldSystemFont(ofSize: 18)
            name.textAlignment = .center
            name.textColor = .black
        }
    }
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(ContactDetailCollectionViewCell.self, forCellWithReuseIdentifier: Constants.collectionViewCell)
            collectionView.backgroundColor = .clear
        }
    }
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.isScrollEnabled = false
            tableView.isUserInteractionEnabled = false
        }
    }
    
    //MARK: View Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        addEditButton()
        fetchContact()
        addGradientLayer()
    }
    
    // update UI 
    public func updateUI() {
        updateDetailsTableViewCellModel()
        updateDetailsCollectionCellModel()
        updateName()
        updateImage()
    }
    
    private func updateDetailsTableViewCellModel() {
        detailCellModel = []
        detailCellModel.append(DetailsTableViewCellModel(name: "Mobile", value: contactModel?.phone_number ?? ""))
        detailCellModel.append(DetailsTableViewCellModel(name: "email", value: contactModel?.email ?? ""))
        tableView.reloadData()
    }
    
    private func updateDetailsCollectionCellModel() {
        collectionCellModel = []
        collectionCellModel.append(ContactDetailCollectionViewCellModel(cellType: .message, isFavourite: false))
        collectionCellModel.append(ContactDetailCollectionViewCellModel(cellType: .call, isFavourite: false))
        collectionCellModel.append(ContactDetailCollectionViewCellModel(cellType: .email, isFavourite: false))
        collectionCellModel.append(ContactDetailCollectionViewCellModel(cellType: .favourite, isFavourite: contactModel?.favorite ?? false))
        collectionView.reloadData()
    }
    
    private func updateName() {
        let firstName = contactModel?.first_name ?? ""
        let lastName = contactModel?.last_name ?? ""
        name.text = firstName + " " + lastName
    }
    
    private func updateImage() {
        if let imageData = contactModel?.image, let image = UIImage(data: imageData, scale: 1.0) {
           profileImageView.image = image
        }
    }
    
    private func addEditButton() {
        let barButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editTapped))
        barButton.tintColor = Constants.greenyColor
        navigationItem.rightBarButtonItem = barButton
    }
    
    @objc func editTapped() {
        print("Edit button tapped")
        
        guard let editContactVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditContactViewController") as? EditContactViewController else { return }
        
        editContactVC.delegate = self
        editContactVC.model = contactModel
        present(editContactVC, animated: true, completion: nil)
    }
    
    // fetch email and phone number
    private func fetchContact() {
        guard let id = contactModel?.id else { return }
        
        spinner.startAnimating()
        Parser.getContacts(id:"\(id)") { [weak self] (contacts) in
            
            if let contact = contacts.first {
                self?.contactModel?.email = contact.email
                self?.contactModel?.phone_number = contact.phone_number
                
                DispatchQueue.main.async {
                    self?.spinner.stopAnimating()
                    self?.updateDetailsTableViewCellModel()
                }
            }
        }
    }
    
    // setup gradients
    private func addGradientLayer() {
        gradientLayer.getGradientEffect(frame: topView.frame)
        topView.layer.insertSublayer(gradientLayer, at: 0)
    }
}
