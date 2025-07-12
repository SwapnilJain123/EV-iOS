//
//  BikeController.swift
//  EvolveGT-iOS
//
//  Created by Swapnil Jain on 05/07/25.
//  Copyright © 2025 YaraTech. All rights reserved.
//

import Foundation
import UIKit
import SkyFloatingLabelTextField

protocol BikeControllerDelegate:AnyObject {
    func didSaveDataSuccessfully()
}

class BikeController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var btnSave: UIButton!

    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate:BikeControllerDelegate?
    
    // Store values from each text field
    var fieldValues: [String] = ["", "", "", "", ""]
    var arrFieldName: [String] = ["Make", "Model", "Year", "CC", "Transponder"]

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
        return arrFieldName.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: BikeTextFieldCell.identifier, for: indexPath) as? BikeTextFieldCell else {
            return UITableViewCell()
        }

        let row = indexPath.row
        cell.configure(placeholder: arrFieldName[indexPath.row], text: fieldValues[row])

        // Capture text changes and update model
        cell.onTextChanged = { [weak self] updatedText in
            self?.fieldValues[row] = updatedText
        }

        return cell
    }
    
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        print("Entered values:", fieldValues)
        delegate?.didSaveDataSuccessfully()
        // You can validate or send this data to API
    }
}
