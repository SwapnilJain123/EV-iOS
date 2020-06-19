//
//  AddressViewController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 12/06/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit
import SkyFloatingLabelTextField

class AddressViewController : ETViewController{
    
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var addressFormContainer: UITableView!
    
    var user = AppEngine.sharedInstance.userDetails
    
    var countries = [String]()
    var states = [String]()
    
    var selectedCountry: Country?
    var selectedState: SupportedState?
    
    var addressType = AddressType.billing
    var hasAddress = false
    private var addressFields = [AddressField]()
    private let interactor = AddressInteractor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interactor.viewDelegate = self
        interactor.addressViewDelegate = self
        addressFields = interactor.getAddressFields(addressType: addressType)
        
        addressFormContainer.dataSource = self
        addressFormContainer.delegate = self
        btnSave.applyColorTheme()
        
        interactor.fetchSupportedCountryList()
        
    }
    
    override func getScreenTitle() -> String? {
        
        if addressType == .billing{
            return hasAddress ? "Edit Billing Address" : "Add Billing Address"
        }else{
            return hasAddress ? "Edit Mailing Address" : "Add Mailing Address"
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.ext.showNavbar()
        self.ext.showBackButton()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.ext.hideNavbar()
    }
    
    @IBAction func didPressSaveButton(_ sender: UIButton) {
        if addressType == .billing{
        interactor.updateBillingAdress(selectedCountry: self.selectedCountry, selectedState: self.selectedState)
        }else{
            interactor.updateShippingAdress(selectedCountry: self.selectedCountry, selectedState: self.selectedState)
        }
    }
}

extension AddressViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        addressFields.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AddressFieldCell.identifier, for: indexPath) as! AddressFieldCell
        
        switch addressFields[indexPath.row] {
        case .firstName:
            cell.errorMessage = ValidationErrors.emptyFirstName
            cell.placeHolder = "First Name*"
            cell.setAction{ text in
                if self.addressType == .billing{
                    self.user?.billingFirstName = text
                }else{
                    self.user?.shippingFirstName = text
                }
            }
            cell.setData(value: addressType == .billing ? user?.billingFirstName : user?.shippingFirstName)
            
        case .lastName:
            cell.errorMessage = ValidationErrors.emptyLastName
            cell.placeHolder = "Last Name*"
            cell.setAction{ text in
                if self.addressType == .billing{
                    self.user?.billingLastName = text
                }else{
                    self.user?.shippingLastName = text
                }
            }
            cell.setData(value: addressType == .billing ? user?.billingLastName : user?.shippingLastName)
        case .companyName:
            cell.errorMessage = ""
            cell.placeHolder = "Company"
            cell.setAction{ text in
                if self.addressType == .billing{
                    self.user?.billingCompany = text
                }else{
                    self.user?.shippingCompany = text
                }
            }
            cell.setData(value: addressType == .billing ? user?.billingCompany : user?.shippingCompany)
        case .country:
            cell.errorMessage = ValidationErrors.countryRequired
            cell.placeHolder = "Country*"
            
            cell.userInputAllowed = false
            cell.setData(value: selectedCountry?.country)
        case .address1:
            cell.errorMessage = ValidationErrors.addressRequired
            cell.placeHolder = "Address1*"
            cell.setAction{ text in
                if self.addressType == .billing{
                    self.user?.billingAddress1 = text
                }else{
                    self.user?.shippingAddress1 = text
                }
            }
            cell.setData(value: addressType == .billing ? user?.billingAddress1 : user?.shippingAddress1)
        case .address2:
            cell.errorMessage = ""
            cell.placeHolder = "Address2"
            cell.setAction{ text in
                if self.addressType == .billing{
                    self.user?.billingAddress2 = text
                }else{
                    self.user?.shippingAddress2 = text
                }
            }
            cell.setData(value: addressType == .billing ? user?.billingAddress2 : user?.shippingAddress2)
        case .city:
            cell.errorMessage = ValidationErrors.cityRequired
            cell.placeHolder = "City*"
            cell.setAction{ text in
                if self.addressType == .billing{
                    self.user?.billingCity = text
                }else{
                    self.user?.shippingCity = text
                }
            }
            cell.setData(value: addressType == .billing ? user?.billingCity : user?.shippingCity)
        case .state:
            cell.errorMessage = ValidationErrors.stateRequired
            cell.placeHolder = "State*"
            cell.userInputAllowed = false
            cell.setData(value: selectedState?.name)
        case .postalCode:
            cell.errorMessage = ValidationErrors.postalCodeRequired
            cell.placeHolder = "Postal Code*"
            cell.setAction{ text in
                if self.addressType == .billing{
                    self.user?.billingPostcode = text
                }else{
                    self.user?.shippingPostcode = text
                }
            }
            cell.setData(value: addressType == .billing ? user?.billingPostcode : user?.shippingPostcode)
        case .phone:
            cell.errorMessage = ValidationErrors.invalidPhoneNumber
            cell.placeHolder = "Phone*"
            cell.setAction{ text in
                if self.addressType == .billing{
                    self.user?.billingPhone = text
                }
            }
            cell.setData(value: user?.billingPhone)
        case .email:
            cell.errorMessage = ValidationErrors.invalidEmail
            cell.placeHolder = "Email*"
            cell.setAction{ text in
                if self.addressType == .billing{
                    self.user?.billingEmail = text
                }
            }
            cell.setData(value: user?.billingEmail)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch addressFields[indexPath.row] {
        case .country:
            
            if self.countries.count > 1{
                self.presentSelectionMenu(title: "Select Country", data: countries){ selectedItems in
                    self.selectedCountry = self.interactor.getSelectedCountry(selectedCountry: selectedItems.first ?? "")
                    self.interactor.fetchSupportedStates(countryCode:  self.selectedCountry?.countryID ?? "")
                    self.addressFormContainer.reloadData()
                }
            }
            
        case .state:
            if self.states.count > 1{
                self.presentSelectionMenu(title: "Select State", data: states){ selectedItems in
                    self.selectedState = self.interactor.getSelectedState(selectedState: selectedItems.first ?? "")
                    self.addressFormContainer.reloadData()
                }
            }
        default:
            Log.d("Ignored")
        }
    }
}

enum AddressType {
    case shipping
    case billing
}

extension AddressViewController: AddressViewDelegate{
    func validationError(message: String, addressField: AddressField) {
        let index = addressFields.index(of: addressField) ?? 0
        let indexPath = IndexPath(row: index, section: 0)
        addressFormContainer.reloadRows(at: [indexPath], with: .automatic)
        addressFormContainer.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    func didFetchSupportedCountries(coutries: [Country]) {
        self.countries.removeAll()
        self.countries.append(contentsOf: coutries.map({
            $0.country ?? ""
        }))
        
        self.selectedCountry = interactor.getSelectedCountry(selectedCountry: (addressType == .billing ? self.user?.billingCountry ?? "" : self.user?.shippingCountry ?? ""))
        
        self.addressFormContainer.reloadData()
    }
    
    func didFetchSupportedStates(states: [SupportedState]) {
        self.states.removeAll()
        self.states.append(contentsOf: states.map({
            $0.name ?? ""
        }))
        self.selectedState = interactor.getSelectedState(selectedState:  (addressType == .billing ? self.user?.billingState ?? "" : self.user?.shippingState ?? ""))
        self.addressFormContainer.reloadData()
    }
    
    
}


class AddressFieldCell : UITableViewCell, UITextFieldDelegate{
    static let identifier = "AddressFieldCell"
    
    @IBOutlet weak var textField: SkyFloatingLabelTextField!
    private var didChangeValue : ((_ text: String?) -> Void)?
    var errorMessage: String?
    var placeHolder: String?
    
    var userInputAllowed = true
    func setAction(action: ((_ text: String?) -> Void)?){
        didChangeValue = action
    }
    func setData(value: String?){
        textField?.applyColorTheme()
        textField?.isUserInteractionEnabled = userInputAllowed
        textField?.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidEnd)
        textField?.addTarget(self, action: #selector(clearErrorMessage(_:)), for: .editingDidBegin)
        
        textField?.text = value
        textField?.placeholder = placeHolder
        if value?.isEmpty ?? true{
            textField?.errorMessage = errorMessage
        }else{
            textField?.errorMessage = ""
        }
    }
    
    @objc func textFieldDidChange(_ textfield: UITextField) {
        if didChangeValue != nil{
            didChangeValue!(textfield.text)
        }
    }
    @objc func clearErrorMessage(_ textfield: UITextField) {
        if let skyFloatingTF = textfield as? SkyFloatingLabelTextField{
            skyFloatingTF.errorMessage = ""
        }
    }
}

