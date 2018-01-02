//
//  ViewController.swift
//  ContactsApp
//
//  Created by Ashis Laha on 30/12/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController {
    
    var model : [Contact] = [] // [list of contacts] used for un-groups
    var groupModel : [String : [Contact]] = [:] // ["A" : [list of A Contacts], ..... ]
    var isGroupEnable : Bool = false
    
    var selectedIndexPath : IndexPath? // store while visiting the details page
    var shouldReloadContact : Bool = false // reload the cell if coming from detail VC
    
    //MARK: Outlets
    @IBOutlet private weak var groupButton: UIBarButtonItem!
    @IBOutlet private weak var contactTableView: UITableView! {
        didSet {
            contactTableView.delegate = self
            contactTableView.dataSource = self
        }
    }
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    
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
    
    public func getContacts() {
        
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
        shouldReloadContact = false
    }
}
