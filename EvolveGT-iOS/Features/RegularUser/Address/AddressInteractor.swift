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
    
    func updateBillingAdress(selectedCountry:Country , selectedState:SupportedState){
        
        self.viewDelegate?.showProgressIndicator(message: LoadingIndicatorMessages.updatingBillingAdress)
        let api = ProfileApi()
        api.setCompletionHandler{data , error in
            
            
            if error == nil{
                self.syncUserDetails()
                self.viewDelegate?.showSuccessToastMessage(message: SuccessMessages.profileUpdated)
            }else{
                self.viewDelegate?.hideProgressIndicator()
                self.viewDelegate?.showErrorToastMessage(message: error?.errorMessage ?? ErrorMessages.genericError)
                
            }
           
        }
        var request = BillingAdressUpdateRequest()
        request.userId = AppEngine.sharedInstance.userID
        
        
        var billingrequest = BillingAdressRequest()
        let user = AppEngine.sharedInstance.userDetails
        billingrequest.billingAdress1 = user!.billingAddress1
        billingrequest.billingAdress2 = user!.billingAddress2
        billingrequest.billingCity = user!.billingCity
        billingrequest.billingCountry = selectedCountry.value
        billingrequest.billingEmail = user!.billingEmail
        billingrequest.billingFirstName = user?.billingFirstName
        billingrequest.billingLastName = user?.billingLastName
        billingrequest.billingPhone = user?.billingPhone
        billingrequest.billingPostCode = user?.billingPostcode
        billingrequest.billingState = selectedState.sortName
        
        request.billingRequest = billingrequest
        
        api.updateBilllingAdress(request: request)
 
        
        
    }
    
    func updateShippingAdress(selectedCountry:Country , selectedState:SupportedState) {
        
        self.viewDelegate?.showProgressIndicator(message: LoadingIndicatorMessages.updatingShippingAdress)
        let api = ProfileApi()
        api.setCompletionHandler{ data, error in
            
            if error == nil{
            
                self.syncUserDetails()
                self.viewDelegate?.showSuccessToastMessage(message: SuccessMessages.profileUpdated)
            }else{
                self.viewDelegate?.hideProgressIndicator()
                self.viewDelegate?.showErrorToastMessage(message: error?.errorMessage ?? ErrorMessages.genericError)
            }
            
        }
        
        var request = ShippingAdressUpdateRequest()
        request.userID = AppEngine.sharedInstance.userID
        
        var shippingRequest = ShippingAddressRequest()
        
        let user = AppEngine.sharedInstance.userDetails
        shippingRequest.shippingAddress1 = user?.shippingAddress1
        shippingRequest.shippingFirstName = user?.shippingFirstName ?? user?.firstName
        shippingRequest.shippingCity  = user?.shippingCity
        shippingRequest.shippingLastName = user?.shippingLastName ?? user?.lastName
        shippingRequest.shippingPostCode = user?.shippingPostcode
        shippingRequest.shippingCountry  = selectedCountry.value
        shippingRequest.shippingState = selectedState.sortName
        
        request.shippingRequest = shippingRequest
        api.updateShippingAdress(request: request)
    
        
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
    private func syncUserDetails() {
        
        let profileApi = ProfileApi()
        profileApi.setCompletionHandler{ response, error in
            
             self.viewDelegate?.hideProgressIndicator()
            if error == nil{
               
                if let userDetailsResponse = self.decodeFromJson(response!, modelType: UserDetailsResponse.self){
                    
                    if userDetailsResponse.userDetails == nil{
                        AppEngine.sharedInstance.userDetails = userDetailsResponse.userDetails
                    }
                }
            }
            
        }
        profileApi.fetchUserDetails(userId: AppEngine.sharedInstance.userID)
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
