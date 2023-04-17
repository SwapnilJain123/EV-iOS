//
//  MembershipInteractor.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 04/06/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
protocol MembershipListDelegate{
    func didFetchMembershipList(memberships : [Membership])
}
protocol MembershipDetailsDelegate{
    func didFetchMembershipDetails(membershipDetails:MembershipDetails)
}

protocol MRLMessageDelegate{
    func didFetchMRLMessage(message:String)
}


class MembershipInteractor : BaseInteractor{
    
    
    var membershipDelegate : MembershipListDelegate?
    var membershipDetailsDelegate : MembershipDetailsDelegate?
    var mrlMessageDelegate: MRLMessageDelegate?
    
    func fetchAvailableMemberships(){
        delegate?.showProgressIndicator(message: LoadingIndicatorMessages.loadingMembershipList)
        if AppEngine.sharedInstance.membership?.isEmpty ?? true{
            self.fetchCurrentMembership()
        }else{
            self.fetchMembershipList()
        }
    }
    private func fetchCurrentMembership(){
        
        let profileApi = ProfileApi()
        profileApi.setCompletionHandler{data, error in
            if error == nil{
                if let response = self.decodeFromJson(data!, modelType: UserMembershipResponse.self){
                    AppEngine.sharedInstance.membership = response.membershipId
                    self.fetchMembershipList()
                }else{
                    self.delegate?.hideEmptyPageError()
                    self.delegate?.hideProgressIndicator()
                    self.delegate?.showEmptyPageError(message: ErrorMessages.genericError)
                }
            }else{
                self.delegate?.hideEmptyPageError()
                self.delegate?.hideProgressIndicator()
                self.delegate?.showEmptyPageError(message: ErrorMessages.genericError)
            }
        }
        profileApi.fetchEnrolledMembership(userId: AppEngine.sharedInstance.userID)
    }
    
    private func fetchMembershipList(){
        
        
        let shopsApi = ShopsApi()
        shopsApi.setCompletionHandler{ data, error in
            
            self.delegate?.hideEmptyPageError()
            self.delegate?.hideProgressIndicator()
            
            if error == nil{
                if let response = self.decodeFromJson(data!, modelType: MembershipListResponse.self){
                    if response.memberships?.count ?? 0 == 0{
                        self.delegate?.showEmptyPageError(message: ErrorMessages.emptyMemberships)
                    }else{
                        for membrship in response.memberships!{
                            membrship.season = response.season
                        }
                        self.membershipDelegate?.didFetchMembershipList(memberships: response.memberships!)
                    }
                }else{
                    self.delegate?.showEmptyPageError(message: ErrorMessages.genericError)
                }
            }else{
                self.delegate?.showEmptyPageError(message: error?.errorMessage ?? ErrorMessages.genericError)
            }
        }
        shopsApi.fetchMembershipList()
    }
    
    func addMembershipToCart(membership: Membership){
        
        delegate?.showProgressIndicator(message: LoadingIndicatorMessages.addingMembershipToCart)
        
        var request = AddMembershipToCartRequest()
        request.image = membership.image
        request.membership = membership.slug
        request.price = membership.price
        request.title = membership.title
        request.userId = AppEngine.sharedInstance.userID
        request.force = AppEngine.sharedInstance.userDetails?.canBuyMRLMembership ?? false ? "0" : "1"
        
        let cartApi = CartApi()
        cartApi.setCompletionHandler{data, error in
            self.delegate?.hideProgressIndicator()
            if error == nil{
                self.delegate?.showSuccessToastMessage(message: SuccessMessages.membershipAddedToCart)
                self.syncCartBadgeCount()
            }else{
                self.delegate?.showErrorToastMessage(message: error?.errorMessage ?? ErrorMessages.genericError)
            }
        }
        cartApi.addMembershipToCart(request: request)
        
    }
    
    func addMembershipToCart(membership: MembershipDetails){
        
        delegate?.showProgressIndicator(message: LoadingIndicatorMessages.addingMembershipToCart)
        
        var request = AddMembershipToCartRequest()
        request.image = membership.image
        request.membership = membership.slug
        request.price = membership.price
        request.title = membership.title
        request.userId = AppEngine.sharedInstance.userID
        request.force = AppEngine.sharedInstance.userDetails?.canBuyMRLMembership ?? false ? "0" : "1"
        
        let cartApi = CartApi()
        cartApi.setCompletionHandler{data, error in
            self.delegate?.hideProgressIndicator()
            if error == nil{
                self.delegate?.showSuccessToastMessage(message: SuccessMessages.membershipAddedToCart)
                self.syncCartBadgeCount()
            }else{
                self.delegate?.showErrorToastMessage(message: error?.errorMessage ?? ErrorMessages.genericError)
            }
        }
        cartApi.addMembershipToCart(request: request)
        
    }
    
    
    func getMembershipDetails(slug:String) {
        
        self.delegate?.showProgressIndicator(message: LoadingIndicatorMessages.loadingMembershipDetails)
        let shopApi = ShopsApi()
        shopApi.setCompletionHandler{data,error in
            
            self.delegate?.hideProgressIndicator()
            
            if error == nil{
                
                let membershipDetailsResponse = self.decodeFromJson(data!, modelType: MembershipDetails.self)
                self.membershipDetailsDelegate?.didFetchMembershipDetails(membershipDetails: membershipDetailsResponse!)
                
            }else{
                
                self.delegate?.showEmptyPageError(message: error?.errorMessage ?? ErrorMessages.genericError)
                
            }
            
        }
        
        shopApi.fetchMembershipDetails(slug: slug)
        
    }
    
    func getMRLMembershipMessage() {
        
        
        let shopApi = ShopsApi()
        shopApi.setCompletionHandler{data,error in
            
            if error == nil{
                
                if let mrlResponse = self.decodeFromJson(data!, modelType: MRLMeesageResponse.self){
                    self.mrlMessageDelegate?.didFetchMRLMessage(message: mrlResponse.msg ?? AppConstants.MRLMessage)
                }else{
                    self.mrlMessageDelegate?.didFetchMRLMessage(message: AppConstants.MRLMessage)
                }
                
            }else{
                
                self.mrlMessageDelegate?.didFetchMRLMessage(message: AppConstants.MRLMessage)
                
            }
            
        }
        
        shopApi.fetchMRLMembershipMessage()
        
    }
}
