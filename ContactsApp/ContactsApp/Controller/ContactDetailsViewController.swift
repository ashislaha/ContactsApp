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
    
    @IBOutlet weak var topView: UIView!
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
        
        updateDetailsCellModel()
    }
    
    private  func updateDetailsCellModel(){
        detailCellModel.append(DetailsTableViewCellModel(name: "Mobile", value: contactModel?.phone_number ?? ""))
        detailCellModel.append(DetailsTableViewCellModel(name: "email", value: contactModel?.email ?? ""))
        tableView.reloadData()
    }
}

//Extension
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

extension ContactDetailsViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("cell tapped")
    }
}
