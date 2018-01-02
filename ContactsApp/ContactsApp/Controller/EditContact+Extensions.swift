//
//  EditContact+Extensions.swift
//  ContactsApp
//
//  Created by Ashis Laha on 02/01/18.
//  Copyright © 2018 Ashis Laha. All rights reserved.
//

import UIKit

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

