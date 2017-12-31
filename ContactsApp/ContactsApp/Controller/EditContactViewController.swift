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
    public weak var delegate : SaveRecordProtocol?
    
    private var detailCellModel : [DetailsTableViewCellModel] = []
    private var imageUrl : String?
    private var gradientLayer = CAGradientLayer()
    private var tappedTextFieldIndex : Int = 0
    
    //MARK: Outlets
    @IBOutlet private weak var topView: UIView!
    
    @IBOutlet private weak var imageButtonOutlet: UIButton! {
        didSet {
            imageButtonOutlet.layer.cornerRadius = imageButtonOutlet.frame.size.height / 2
            imageButtonOutlet.clipsToBounds = true
        }
    }
    
    @IBOutlet private weak var tableView: UITableView! {
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
        
        var dict : [String : Any] = [:]
        
        if let id = model?.id {
            dict[Constants.id] = id
        }
        if let image = self.imageButtonOutlet.image(for: .normal), let data = UIImagePNGRepresentation(image) {
            dict[Constants.imageData] = data
        }
        if let cell1 = self.getCell(row: 0, section: 0), let firstName = cell1.value.text {
            dict[Constants.firstName] = firstName
        }
        if let cell2 = self.getCell(row: 1, section: 0), let lastName = cell2.value.text {
            dict[Constants.lastName] = lastName
        }
        if let cell3 = self.getCell(row: 2, section: 0), let phoneNumber = cell3.value.text {
            dict[Constants.phoneNumber] = phoneNumber
        }
        if let cell4 = self.getCell(row: 3, section: 0), let emailId = cell4.value.text {
            dict[Constants.email] = emailId
        }
        
        if self.model == nil { // coming from Home Screen by Add tapped
            dict[Constants.createdAt] = "\(Date())"
        } else { // From Details Page
            dict[Constants.updatedAt] = "\(Date())"
        }
        
        if let imageUrl = self.imageUrl {
            dict[Constants.profilePic] = imageUrl
        }
        
        let contactModel = Contact(dict: dict)
        doNetworkCall(contactModel: contactModel)
    }
    
    private func doNetworkCall(contactModel : Contact) {
        guard let firstName = contactModel.first_name, let lastName = contactModel.last_name, !firstName.isEmpty, !lastName.isEmpty else { return }
        
        if model == nil { // POST request - New Contact
            Parser.updateContact(contact: contactModel, requestType: .POST) { [weak self] (response)  in
                self?.handleResponse(response: response, contactModel: contactModel)
            }
            
        } else { // PUT - Update Contact
            Parser.updateContact(contact: contactModel, requestType: .PUT) { [weak self] (response) in
                self?.handleResponse(response: response, contactModel: contactModel)
            }
        }
    }
    
    private func handleResponse(response : Any?, contactModel : Contact) {
        guard let response = response as? [String : Any]  else { return }
        // handle error case
        if let errors = response["errors"] as? [String] {
            showAlert(header: "ERROR", message: errors.description)
        } else {
            // on succssful POST
            dismiss(animated: true) {
                self.delegate?.save(model: contactModel)
            }
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerKeyboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: Keyboard notification
    private func registerKeyboard() {
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc private func keyboardWillShow(_ sender: Notification) {
        
        if let keyboardFrame = sender.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect {
            let edgeInsets: UIEdgeInsets = UIEdgeInsetsMake(0, 0, keyboardFrame.size.height, 0)
            tableView.contentInset = edgeInsets
            tableView.scrollIndicatorInsets = edgeInsets
            let indexPath = IndexPath(row: tappedTextFieldIndex , section: 0)
            tableView.scrollToRow(at: indexPath, at: .none, animated: false)
        }
    }
    
    @objc private func keyboardWillHide(_ sender: Notification) {
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            self?.tableView.contentInset = .zero
            self?.tableView.scrollIndicatorInsets = .zero
        })
    }
    
    //MARK: updateUI
    private func updateUI() {
        updateImage()
        updateDetailsTableViewCellModel()
        addGradientLayer()
    }
    
    private func updateImage() {
        if let imageData = model?.image, let image = UIImage(data: imageData, scale: 1.0) {
            imageButtonOutlet.setImage(image, for: .normal)
            imageButtonOutlet.layer.borderWidth = 1
            imageButtonOutlet.layer.borderColor = UIColor.black.cgColor
        }
    }
    
    private func updateDetailsTableViewCellModel() {
        detailCellModel = []
        detailCellModel.append(DetailsTableViewCellModel(name: "First Name", value: model?.first_name ?? ""))
        detailCellModel.append(DetailsTableViewCellModel(name: "Last Name", value: model?.last_name ?? ""))
        detailCellModel.append(DetailsTableViewCellModel(name: "Mobile", value: model?.phone_number ?? ""))
        detailCellModel.append(DetailsTableViewCellModel(name: "email", value: model?.email ?? ""))
        tableView.reloadData()
    }
    
    // setup gradients
    private func addGradientLayer() {
        gradientLayer.getGradientEffect(frame: topView.frame)
        topView.layer.insertSublayer(gradientLayer, at: 0)
    }
}

//MARK: UIImagePickerControllerDelegate
extension EditContactViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else { return }
        imageUrl = info[UIImagePickerControllerImageURL] as? String
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
        cell.value.tag = indexPath.row // to retrive the cell identity while tapping on textfield
        cell.delegate = self
        return cell
    }
}

//MARK: UITableViewDelegate
extension EditContactViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("cell tapped")
    }
}

//MARK: EditCellDelegate
extension EditContactViewController : EditCellDelegate {
    
    func getIndex(val: Int) {
        tappedTextFieldIndex = val
    }
    
    func getValue(text: String?, index: Int) {
        detailCellModel[index].value = text ?? ""
    }
}
