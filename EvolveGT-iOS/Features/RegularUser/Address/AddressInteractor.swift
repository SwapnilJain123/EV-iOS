//
//  AddressInteractor.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 12/06/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation

protocol AddressViewDelegate{
    func didFetchSupportedCountries(coutries: [Country])
    func didFetchSupportedStates(states: [SupportedState])
}
class AddressInteractor : BaseInteractor{
    
  
    var viewDelegate : BaseViewDelegate? = nil
    var addressViewDelegate: AddressViewDelegate? = nil
    
    func getAddressFields(addressType: AddressType) ->[AddressField]{
        var fields = [AddressField]()
        for value in AddressField.allCases {
            fields.append(value)
        }
        
        if addressType == AddressType.shipping{
            fields = fields.filter({
                $0 != .email && $0 != .phone
            })
        }
    
        return fields
    }
    
    
    func fetchSupportedCountryList(){
        
        if AppEngine.sharedInstance.countries.count > 0{
            addressViewDelegate?.didFetchSupportedCountries(coutries: AppEngine.sharedInstance.countries)
            if AppEngine.sharedInstance.countries.count == 1{
                self.fetchSupportedStates(countryCode: AppEngine.sharedInstance.countries.first?.countryID ?? "")
            }
            return
        }
        self.viewDelegate?.showProgressIndicator(message: LoadingIndicatorMessages.loading)
        let api = GenericApi()
        api.setCompletionHandler{ data, error in
            self.viewDelegate?.hideProgressIndicator()
            if error == nil{
                if let response = self.decodeFromJson(data!, modelType: CountryListResponse.self){
                    
                    if response.supportedCountries?.count ?? 0 > 0{
                        AppEngine.sharedInstance.countries = response.supportedCountries!
                        self.addressViewDelegate?.didFetchSupportedCountries(coutries: response.supportedCountries!)
                        if response.supportedCountries?.count ?? 0 == 1{
                            self.fetchSupportedStates(countryCode: response.supportedCountries?.first?.countryID ?? "")
                        }
                    }else{
                        self.viewDelegate?.showAlert(title: "", message: ErrorMessages.genericError)
                    }
                    
                }else{
                    self.viewDelegate?.showAlert(title: "", message: ErrorMessages.genericError)
                }
            }else{
                self.viewDelegate?.showAlert(title: "", message: error?.errorMessage ?? ErrorMessages.genericError)
            }
        }
        api.fetchSupportedCountries()
    }
    func fetchSupportedStates(countryCode: String){
        
        if AppEngine.sharedInstance.countries.count == 1 && AppEngine.sharedInstance.states.count > 0{
            addressViewDelegate?.didFetchSupportedStates(states:  AppEngine.sharedInstance.states)
            return
        }
        
        self.viewDelegate?.showProgressIndicator(message: LoadingIndicatorMessages.loading)
        let api = GenericApi()
        api.setCompletionHandler{ data, error in
            
            self.viewDelegate?.hideProgressIndicator()
            if error == nil{
                
                if let response = self.decodeFromJson(data!, modelType: StateListResponse.self){
                    
                    if response.supportedStates?.count ?? 0 > 0{
                        AppEngine.sharedInstance.states = response.supportedStates!
                        self.addressViewDelegate?.didFetchSupportedStates(states: response.supportedStates!)
                    }else{
                        self.viewDelegate?.showAlert(title: "", message: ErrorMessages.genericError)
                    }
                    
                }else{
                    self.viewDelegate?.showAlert(title: "", message: ErrorMessages.genericError)
                }
            }else{
                self.viewDelegate?.showAlert(title: "", message: error?.errorMessage ?? ErrorMessages.genericError)
            }
        }
        api.fetchSupportedStates(countryCode: countryCode)
    }
    
    func getSelectedCountry(selectedCountry: String) -> Country{
         let countryIndex = AppEngine.sharedInstance.countries
            .firstIndex(where: {
                $0.value == selectedCountry || $0.country == selectedCountry
                
            }) ?? 0
        return AppEngine.sharedInstance.countries[countryIndex]
        
    }
    func getSelectedState(selectedState: String) -> SupportedState{
         let stateIndex = AppEngine.sharedInstance.states.firstIndex(where: { $0.name == selectedState || $0.sortName == selectedState}) ?? 0
        return AppEngine.sharedInstance.states[stateIndex]
        
    }
}
enum AddressField: Int, CaseIterable{
    case firstName
    case lastName
    case companyName
    case country
    case address1
    case address2
    case city
    case state
    case postalCode
    case phone
    case email
}
