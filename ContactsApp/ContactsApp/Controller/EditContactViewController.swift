//
//  EditContactViewController.swift
//  ContactsApp
//
//  Created by Ashis Laha on 30/12/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//

import UIKit

protocol SaveRecordProtocol : class {
    func save(model : Contact)
}


class EditContactViewController: UIViewController {

    public var model : Contact?
    private var detailCellModel : [DetailsTableViewCellModel] = []
    public weak var delegate : SaveRecordProtocol?
    
    //MARK: Outlets
    @IBOutlet private weak var topView: UIView!
    
    @IBOutlet weak var imageButtonOutlet: UIButton! {
        didSet {
            imageButtonOutlet.layer.cornerRadius = imageButtonOutlet.frame.size.height / 2
            imageButtonOutlet.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.allowsSelection = false
        }
    }
    
    //MARK: IBActions
    @IBAction private func cancelTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func doneTapped(_ sender: UIButton) {
        
        dismiss(animated: true) { [weak self] in
           
            var dict : [String : Any] = [:]
            if let image = self?.imageButtonOutlet.image(for: .normal), let data = UIImagePNGRepresentation(image) {
                dict[Constants.imageData] = data
            }
            if let cell1 = self?.getCell(row: 0, section: 0), let firstName = cell1.value.text {
                dict[Constants.firstName] = firstName
            }
            if let cell2 = self?.getCell(row: 1, section: 0), let lastName = cell2.value.text {
                dict[Constants.lastName] = lastName
            }
            if let cell3 = self?.getCell(row: 2, section: 0), let phoneNumber = cell3.value.text {
                dict[Constants.phoneNumber] = phoneNumber
            }
            if let cell4 = self?.getCell(row: 3, section: 0), let emailId = cell4.value.text {
                dict[Constants.email] = emailId
            }
            
            if self?.model == nil { // coming from Home Screen by Add tapped
                dict[Constants.createdAt] = "\(Date())"
            } else { // From Details Page
                dict[Constants.updatedAt] = "\(Date())"
            }
           
            let contactModel = Contact(dict: dict)
            self?.delegate?.save(model: contactModel)
        }
    }
    
    private func getCell(row: Int, section : Int) -> EditTableViewCell? {
        guard let cell = tableView.cellForRow(at: IndexPath(row: row, section: section)) as? EditTableViewCell else { return nil }
        return cell
    }
    
    @IBAction func imageTapped(_ sender: UIButton) {
        print("change image")
        
        let alertController = UIAlertController(title: "Change Picture", message: nil, preferredStyle: .alert)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { [weak self] (alertAction) in
            
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return } // if available then proceed
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .camera
            imagePickerController.allowsEditing = true
            imagePickerController.delegate = self
            self?.present(imagePickerController, animated: true, completion: nil)
        }
        
        let photoAction =  UIAlertAction(title: "Photo Library", style: .default) { [weak self] (alertAction) in
            
            guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return } // if available then proceed
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.allowsEditing = true
            imagePickerController.delegate = self
            self?.present(imagePickerController, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cameraAction)
        alertController.addAction(photoAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    //MARK: View Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }
    
    //MARK: updateUI
    private func updateUI() {
        updateImage()
        updateDetailsTableViewCellModel()
        
    }
    
    private func updateImage() {
        if let imageData = model?.image, let image = UIImage(data: imageData, scale: 1.0) {
            imageButtonOutlet.setImage(image, for: .normal)
            imageButtonOutlet.layer.borderWidth = 1
            imageButtonOutlet.layer.borderColor = UIColor.black.cgColor
        }
    }
    
    private func updateDetailsTableViewCellModel() {
        detailCellModel.append(DetailsTableViewCellModel(name: "First Name", value: model?.first_name ?? ""))
        detailCellModel.append(DetailsTableViewCellModel(name: "Last Name", value: model?.last_name ?? ""))
        detailCellModel.append(DetailsTableViewCellModel(name: "Mobile", value: model?.phone_number ?? ""))
        detailCellModel.append(DetailsTableViewCellModel(name: "email", value: model?.email ?? ""))
        tableView.reloadData()
    }
}

//MARK:- UIImagePickerControllerDelegate
extension EditContactViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else { return }
        imageButtonOutlet.setImage(image, for: .normal)
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK: UITableViewDataSource
extension EditContactViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailCellModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.editCell, for: indexPath) as? EditTableViewCell else { return UITableViewCell() }
        
        cell.model = detailCellModel[indexPath.row]
        return cell
    }
}

//MARK: UITableViewDelegate
extension EditContactViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
