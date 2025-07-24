////
////  BikeController.swift
////  EvolveGT-iOS
////
////  Created by Swapnil Jain on 05/07/25.
////  Copyright © 2025 YaraTech. All rights reserved.
////
//
import Foundation
import UIKit
import SkyFloatingLabelTextField

protocol BikeControllerDelegate:AnyObject {
    func didSaveDataSuccessfully(bikeData:Bike)
}

class BikeController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: BikeControllerDelegate?
    
    private var yearList: [Int] = {
        let currentYear = Calendar.current.component(.year, from: Date())
        return (1900...currentYear).reversed()
    }()
    
    private var activeYearRowIndex: Int?
    
    var arrFieldName: [[String: String]] = [
        ["title": "Make", "value": "", "error": ""],
        ["title": "Model", "value": "", "error": ""],
        ["title": "Year", "value": "", "error": ""],
        ["title": "CC", "value": "", "error": ""],
        ["title": "Transponder", "value": "", "error": ""]
    ]
    
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
        
        let data = arrFieldName[indexPath.row]
        let title = data["title"] ?? ""
        let value = data["value"] ?? ""
        let error = data["error"] ?? ""
        
        cell.configure(placeholder: title, text: value, error: error)
        
        cell.onTextChanged = { [weak self] updatedText in
            self?.arrFieldName[indexPath.row]["value"] = updatedText
            self?.arrFieldName[indexPath.row]["error"] = ""
        }
        
        cell.validateText = { text in
            let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmed.isEmpty {
                return "\(title) is required"
            }
            return nil
        }
        
        if title == "Year" {
            let picker = UIPickerView()
            picker.delegate = self
            picker.dataSource = self
            picker.tag = indexPath.row
            activeYearRowIndex = indexPath.row
            
            if let selectedYear = Int(value), let row = yearList.firstIndex(of: selectedYear) {
                picker.selectRow(row, inComponent: 0, animated: false)
            }
            
            let toolbar = UIToolbar()
            toolbar.sizeToFit()
            let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(yearPickerDoneTapped))
            toolbar.setItems([.flexibleSpace(), done], animated: false)
            
            cell.setInputView(picker)
            cell.setInputAccessoryView(toolbar)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    @objc func yearPickerDoneTapped() {
        view.endEditing(true)
        
        guard let index = activeYearRowIndex else { return }
        
        let picker = UIPickerView()
        let selectedRow = picker.selectedRow(inComponent: 0)
        let selectedYear = yearList[selectedRow]
        
        arrFieldName[index]["value"] = "\(selectedYear)"
        arrFieldName[index]["error"] = ""
        
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        var isValid = true
        
        for index in 0..<arrFieldName.count {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) as? BikeTextFieldCell {
                if let error = cell.forceValidate() {
                    arrFieldName[index]["error"] = error
                    isValid = false
                } else {
                    arrFieldName[index]["error"] = ""
                }
            }
        }
        if isValid {
            print("Entered values:", arrFieldName)
            
            // Create a temporary dictionary to map field values
            var bikeDict: [String: String] = [:]
            for item in arrFieldName {
                if let key = item["title"]?.lowercased(), let value = item["value"] {
                    bikeDict[key] = value
                }
            }

            // Safely unwrap all values to initialize the Bike model
            if let make = bikeDict["make"],
               let model = bikeDict["model"],
               let cc = bikeDict["cc"],
               let year = bikeDict["year"],
               let transponder = bikeDict["transponder"] {

                let bike = Bike(make: make, model: model, cc: cc, year: year, transponder: transponder)
                print("Final Bike object:", bike)
                delegate?.didSaveDataSuccessfully(bikeData: bike)
                self.navigationController?.popViewController(animated: true)
            } else {
                print("Error: Missing fields in bikeDict")
            }

        } else {
            tableView.reloadData()
        }
    }
}


extension BikeController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return yearList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(yearList[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let index = activeYearRowIndex else { return }
        arrFieldName[index]["value"] = "\(yearList[row])"
        arrFieldName[index]["error"] = ""
        
        let indexPath = IndexPath(row: index, section: 0)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}
