//
//  ViewController.swift
//  ContactsApp
//
//  Created by Ashis Laha on 30/12/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController {

    var model : [Contact] = []
    private var selectedIndexPath : IndexPath? // store while visiting the details page
    private var shouldReloadContact : Bool = false
    
    //MARK: Outlets
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
    
    private func relaodContactIfRequired() {
        guard let selectedIndexPath = selectedIndexPath, let id = model[selectedIndexPath.row].id else { return }
        
        // call a GET request only that contact
        Parser.getContacts(id: "\(id)", callback: { (contacts) in
            
            DispatchQueue.main.async { [weak self] in
                if let contact = contacts.first {
                    self?.model[selectedIndexPath.row] = contact
                    self?.contactTableView.reloadRows(at: [selectedIndexPath], with: .fade)
                }
            }
        })
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
    
    private func getContacts() {
        
        spinner.startAnimating()
        Parser.getContacts { [weak self] (contacts) in
            // UI update on main thread
            DispatchQueue.main.async {
                self?.model = contacts
                self?.contactTableView.reloadData()
                self?.spinner.stopAnimating()
            }
        }
    }
    
    //MARK: IBActions
    @IBAction func groupsTapped(_ sender: UIBarButtonItem) {
        print("group tapped")
    }
    
    @IBAction func addTapped(_ sender: UIBarButtonItem) {
        print("add tapped")
        
        guard let editContactVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditContactViewController") as? EditContactViewController else { return }
        
        editContactVC.delegate = self
        editContactVC.model = nil
        present(editContactVC, animated: true, completion: nil)
    }
}

//MARK: UITableViewDataSource
extension HomeScreenViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.contactCellId, for: indexPath) as? ContactTableViewCell else { return UITableViewCell() }
        
        cell.model = model[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.headerID) as? ContactHeaderView else { return nil }
        header.viewSetup()
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
        detailVC.contactModel = model[indexPath.row]
        
        if let cell = tableView.cellForRow(at: indexPath) as? ContactTableViewCell { // using the downloaded image, save some data..
            if let image = cell.profileImage.image, let data = UIImagePNGRepresentation(image) {
                detailVC.contactModel?.image = data
            }
        }
        
        navigationController?.pushViewController(detailVC, animated: true)
        shouldReloadContact = true
    }
}

//MARK: SaveRecordProtocol
extension HomeScreenViewController : SaveRecordProtocol {
    
    func save(model: Contact) { // new contact
        shouldReloadContact = false
        getContacts()
    }
}

