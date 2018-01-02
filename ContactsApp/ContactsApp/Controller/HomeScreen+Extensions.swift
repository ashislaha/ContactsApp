//
//  HomeScreen+Extensions.swift
//  ContactsApp
//
//  Created by Ashis Laha on 02/01/18.
//  Copyright © 2018 Ashis Laha. All rights reserved.
//

import UIKit

//MARK: UITableViewDataSource
extension HomeScreenViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return isGroupEnable ? 27 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isGroupEnable {
            if let contacts = groupModel[Constants.alphabet[section]] {
                return contacts.count
            } else {
                return 0
            }
        }  else {
            return model.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.contactCellId, for: indexPath) as? ContactTableViewCell else { return UITableViewCell() }
        
        cell.model = isGroupEnable ? groupModel[Constants.alphabet[indexPath.section]]?[indexPath.row]  : model[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.headerID) as? ContactHeaderView else { return nil }
        header.viewSetup()
        header.title = isGroupEnable ? Constants.alphabet[section] : Constants.all
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
}

//MARK: UITableViewDelegate
extension HomeScreenViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\n\(model[indexPath.row])")
        
        guard let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ContactDetailsViewController") as? ContactDetailsViewController else { return }
        
        selectedIndexPath = indexPath
        detailVC.contactModel = isGroupEnable ? groupModel[Constants.alphabet[indexPath.section]]?[indexPath.row]  : model[indexPath.row]
        
        if let cell = tableView.cellForRow(at: indexPath) as? ContactTableViewCell { // using the downloaded image, save some data..
            if let image = cell.profileImage.image, let data = UIImagePNGRepresentation(image) {
                detailVC.contactModel?.image = data
            }
        }
        
        navigationController?.pushViewController(detailVC, animated: true)
        shouldReloadContact = true
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return isGroupEnable ? Constants.alphabet : []
    }
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return isGroupEnable ? Constants.alphabet.index(of: title) ?? 0 : 0
    }
}

//MARK: SaveRecordProtocol
extension HomeScreenViewController : SaveRecordProtocol {
    
    func save(model: Contact) {
        getContacts()
    }
}

