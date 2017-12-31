//
//  ViewController.swift
//  ContactsApp
//
//  Created by Ashis Laha on 30/12/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController {

    private var model : [Contact] = []
    private var groupModel : [String : [Contact]] = [:] // ["A" : [list of A Contacts], ..... ]
    private var isGroupEnable : Bool = false 
    
    private var selectedIndexPath : IndexPath? // store while visiting the details page
    private var shouldReloadContact : Bool = false
    
    //MARK: Outlets
    
    @IBOutlet weak var groupButton: UIBarButtonItem!
    @IBOutlet private weak var contactTableView: UITableView! {
        didSet {
            contactTableView.delegate = self
            contactTableView.dataSource = self
        }
    }
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    //MARK: View Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Contacts"
        registers()
        tableViewSetup()
        getContacts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // reload the cell if coming from detail VC
        if shouldReloadContact {
            relaodContactIfRequired()
        }
    }
    private func registers() {
        contactTableView.register(ContactHeaderView.self, forHeaderFooterViewReuseIdentifier: Constants.headerID)
    }
    
    private func tableViewSetup() {
        // resize based on content
        contactTableView.rowHeight = UITableViewAutomaticDimension
        contactTableView.estimatedRowHeight = 100
        
        contactTableView.reloadData()
        contactTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        contactTableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    //MARK: Contacts Handling
    
    private func relaodContactIfRequired() {
        guard let selectedIndexPath = selectedIndexPath else { return }
        
        var id = 0
        if isGroupEnable {
            if let identity = groupModel[Constants.alphabet[selectedIndexPath.section]]?[selectedIndexPath.row].id {
                id = identity
            }
        } else {
            if let identity = model[selectedIndexPath.row].id {
                id = identity
            }
        }
       
        guard id != 0 else { return }
        
        // call a GET request only that contact
        Parser.getContacts(id: "\(id)", callback: { (contacts) in
            
            DispatchQueue.main.async { [weak self] in
                if let contact = contacts.first {
                    
                    if let isGroupEnable = self?.isGroupEnable, isGroupEnable {
                        self?.groupModel[Constants.alphabet[selectedIndexPath.section]]?[selectedIndexPath.row] = contact
                    } else {
                        self?.model[selectedIndexPath.row] = contact
                    }
                    self?.contactTableView.reloadRows(at: [selectedIndexPath], with: .fade)
                }
            }
        })
    }
    
    private func getContacts() {
        
        spinner.startAnimating()
        Parser.getContacts { [weak self] (contacts) in
            
            self?.model = contacts
            self?.convertGroupContacts(contacts: contacts)
            
            // UI update on main thread
            DispatchQueue.main.async {
                self?.contactTableView.reloadData()
                self?.spinner.stopAnimating()
            }
        }
    }
    
    private func convertGroupContacts(contacts : [Contact] ) {
        groupModel = Parser.getGroupContacts(contacts: contacts)
    }
    
    //MARK: IBActions
    @IBAction func groupsTapped(_ sender: UIBarButtonItem) {
        isGroupEnable = !isGroupEnable
        groupButton.title = isGroupEnable ? "Un-Groups" : "Groups"
        contactTableView.reloadData()
    }
    
    @IBAction func addTapped(_ sender: UIBarButtonItem) {
        
        guard let editContactVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditContactViewController") as? EditContactViewController else { return }
        
        editContactVC.delegate = self
        editContactVC.model = nil
        present(editContactVC, animated: true, completion: nil)
    }
}

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
        header.title = Constants.alphabet[section]
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
        return Constants.alphabet
    }
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return Constants.alphabet.index(of: title) ?? 0
    }
}

//MARK: SaveRecordProtocol
extension HomeScreenViewController : SaveRecordProtocol {
    
    func save(model: Contact) { // new contact
        shouldReloadContact = false
        getContacts()
    }
}

