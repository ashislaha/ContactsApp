//
//  EditScreenViewController.swift
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

class ContactDetailsViewController: UIViewController {

    public var contactModel : Contact?
    public var importImage : UIImage?
    
    private var detailCellModel : [DetailsTableViewCellModel] = []
    private var collectionCellModel : [ContactDetailCollectionViewCellModel] = []
    
    // topview
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var profileImageView: UIImageView! {
        didSet {
            profileImageView.layer.cornerRadius = profileImageView.frame.size.height/2
            profileImageView.clipsToBounds = true
            profileImageView.layer.borderWidth = 3
            profileImageView.layer.borderColor = UIColor.green.cgColor
        }
    }
    
    @IBOutlet weak var name: UILabel! {
        didSet {
            name.font = UIFont.boldSystemFont(ofSize: 18)
            name.textAlignment = .center
            name.textColor = .black
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(ContactDetailCollectionViewCell.self, forCellWithReuseIdentifier: Constants.collectionViewCell)
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
    
    // View Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    // update UI 
    private func updateUI() {
        updateDetailsCellModel()
        updateDetailsCollectionCellModel()
        addEditButton()
        updateName()
        updateImage()
    }
    
    private  func updateDetailsCellModel(){
        detailCellModel.append(DetailsTableViewCellModel(name: "Mobile", value: contactModel?.phone_number ?? ""))
        detailCellModel.append(DetailsTableViewCellModel(name: "email", value: contactModel?.email ?? ""))
        tableView.reloadData()
    }
    
    private func updateDetailsCollectionCellModel() {
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
        if let image = importImage {
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
    }
}

//MARK: UITableViewDataSource
extension ContactDetailsViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailCellModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.detailCell, for: indexPath) as? ContactDetailTableViewCell else { return UITableViewCell() }
        
        cell.model = detailCellModel[indexPath.row]
        return cell
    }
}

//MARK: UITableViewDelegate
extension ContactDetailsViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

//MARK: UICollectionViewDataSource
extension ContactDetailsViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionCellModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.collectionViewCell, for: indexPath) as? ContactDetailCollectionViewCell else { return UICollectionViewCell() }
        
        cell.model = collectionCellModel[indexPath.row]
        return cell
    }
}

//MARK: UICollectionViewDelegate
extension ContactDetailsViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellType = collectionCellModel[indexPath.row].cellType
        switch cellType {
        case .message:
            print("Message tapped")
            
        case .call:
            print("call tapped")
            
        case .email:
            print("email tapped")
            
        case .favourite:
            print("favourite tapped")
            
            guard let isFavourite = contactModel?.favorite else { return }
            contactModel?.favorite = !isFavourite // update contact model
            collectionCellModel[3].isFavourite = !isFavourite // update collection view cell model
            collectionView.reloadItems(at: [indexPath])
            
            // do a PUT call to update the favourite
            if let contactModel = contactModel {
                Parser.postContact(contact:contactModel, requestType: .put)
            }
        }
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension ContactDetailsViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width/CGFloat(collectionCellModel.count) - 10, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
}
