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
    
    private var detailCellModel : [DetailsTableViewCellModel] = []
    private var collectionCellModel : [CellType] = [ .message, .call, .email, .favourite]
    
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
        addEditButton()
        updateName()
        updateImage()
    }
    
    private func updateName() {
        let firstName = contactModel?.first_name ?? ""
        let lastName = contactModel?.last_name ?? ""
        name.text = firstName + " " + lastName
    }
    
    private  func updateDetailsCellModel(){
        detailCellModel.append(DetailsTableViewCellModel(name: "Mobile", value: contactModel?.phone_number ?? ""))
        detailCellModel.append(DetailsTableViewCellModel(name: "email", value: contactModel?.email ?? ""))
        tableView.reloadData()
    }
    
    private func updateImage() {
        if let imageUrl = contactModel?.profile_pic {
            loadImage(urlString: imageUrl)
        }
    }
    
    private func loadImage(urlString : String)  {
        guard let url = URL(string: urlString) else { return }
        let session = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else { return }
            
            DispatchQueue.main.async { [weak self] in
                guard let image = UIImage(data: data) else { return }
                self?.profileImageView.image = image
            }
        }
        session.resume()
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
        print("cell tapped")
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
        
        cell.cellType = collectionCellModel[indexPath.row]
        return cell
    }
}

//MARK: UICollectionViewDelegate
extension ContactDetailsViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("tapped : \(indexPath)")
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
