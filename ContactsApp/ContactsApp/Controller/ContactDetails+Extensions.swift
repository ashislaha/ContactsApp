//
//  ContactDetails+Extensions.swift
//  ContactsApp
//
//  Created by Ashis Laha on 02/01/18.
//  Copyright © 2018 Ashis Laha. All rights reserved.
//

import UIKit
import MessageUI

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
            sendMessage()
            
        case .call:
            print("call tapped")
            sendCall()
            
        case .email:
            print("email tapped")
            sendMail()
            
        case .favourite:
            print("favourite tapped")
            favouriteTapped(indexPath: indexPath)
        }
    }
    
    private func sendMessage() {
        guard let contactNumber = contactModel?.phone_number else { return }
        if let url = URL(string: "sms:\(contactNumber)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            showAlert(header: "Cannot send SMS", message: "This Facility is not available")
        }
    }
    
    private func sendCall() {
        guard let contactNumber = contactModel?.phone_number else { return }
        if let url = URL(string: "tel://\(contactNumber)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            showAlert(header: "Call Unavailable", message: "This Facility is not available for this device")
        }
    }
    
    private func sendMail() {
        guard let emailId = contactModel?.email else { return }
        
        if MFMailComposeViewController.canSendMail() {
            let mailController = MFMailComposeViewController()
            mailController.setToRecipients([emailId])
            mailController.delegate = self
            present(mailController, animated: true, completion: nil)
        } else {
            showAlert(header: "Cannot send Mail", message: "This Facility is not available")
        }
    }
    
    private func favouriteTapped(indexPath : IndexPath) {
        guard let isFavourite = contactModel?.favorite else { return }
        contactModel?.favorite = !isFavourite // update contact model
        collectionCellModel[3].isFavourite = !isFavourite // update collection view cell model
        collectionView.reloadItems(at: [indexPath])
        
        // do a PUT call to update the favourite
        if let contactModel = contactModel {
            Parser.updateContact(contact:contactModel, requestType: .PUT) // no need of error handling here
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

//MARK: SaveRecordProtocol
extension ContactDetailsViewController : SaveRecordProtocol {
    func save(model: Contact) {
        
        if let imageData = model.image {
            contactModel?.image = imageData
        }
        if let firstName = model.first_name {
            contactModel?.first_name = firstName
        }
        if let lastName = model.last_name {
            contactModel?.last_name = lastName
        }
        if let phoneNumber = model.phone_number {
            contactModel?.phone_number = phoneNumber
        }
        if let emailId = model.email {
            contactModel?.email = emailId
        }
        if let updateAt = model.updated_at {
            contactModel?.updated_at = updateAt
        }
        if let profileUrl = model.profile_pic {
            contactModel?.profile_pic = profileUrl
        }
        updateUI()
    }
}

//MARK: MFMailComposeViewControllerDelegate
extension ContactDetailsViewController : MFMailComposeViewControllerDelegate, UINavigationControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        } else {
            switch result {
            case .cancelled : print("Mail sending cancelled")
            case .failed: print("Mail sending failed")
            case .saved: print("Mail has saved")
            case .sent: print("Mail has sent")
            }
        }
        controller.dismiss(animated: true, completion: nil)
    }
}


