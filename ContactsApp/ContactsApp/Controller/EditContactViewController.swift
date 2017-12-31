//
//  EditContactViewController.swift
//  ContactsApp
//
//  Created by Ashis Laha on 30/12/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//

import UIKit

class EditContactViewController: UIViewController {

    public var model : Contact?
    public var importedImage : UIImage?
    private var detailCellModel : [DetailsTableViewCellModel] = []
    
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
        
        dismiss(animated: true) {
            // call some delegate to get the updates in Details page 
        }
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
        if let importedImage = importedImage {
            imageButtonOutlet.setImage(importedImage, for: .normal)
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
