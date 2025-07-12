//
//  SponsorController.swift
//  EvolveGT-iOS
//
//  Created by Swapnil Jain on 06/07/25.
//  Copyright © 2025 YaraTech. All rights reserved.
//


import Foundation
import UIKit
import SkyFloatingLabelTextField

protocol SponsorControllerDelegate:AnyObject {
    func didSponsorSelected()
}

class SponsorController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var btnSave: UIButton!

    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate:SponsorControllerDelegate?
    
    // Store values from each text field
    var fieldValues: [String] = ["", "", "", "", ""]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        btnSave.applyColorTheme()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.ext.showNavbar()
        self.ext.showBackButton()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fieldValues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SponsorCell.identifier, for: indexPath) as? SponsorCell else {
            return UITableViewCell()
        }
        cell.configure(text: "Sponsor")
        cell.selectionStyle = .none
        return cell
    }
    
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        print("Entered values:", fieldValues)
        delegate?.didSponsorSelected()
        // You can validate or send this data to API
    }
}
