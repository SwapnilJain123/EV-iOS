//
//  ProfileInteractor.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 05/06/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit
protocol ProfileViewDelegate{
    func availableSections(sections: [ProfileSections])
    func validationError(message: String, section: ProfileSections)
}
class ProfileInteractor : BaseInteractor{
    
    var profileViewDelegate : ProfileViewDelegate?
    var viewDelegate : BaseViewDelegate?
    
    func computeProfileSections(){
        var sections = [ProfileSections]()
        for value in ProfileSections.allCases {
            sections.append(value)
        }
        
        if AppEngine.sharedInstance.isEvApp(){
            sections.removeAll(where: {$0 == .moto})
        }
        self.profileViewDelegate?.availableSections(sections: sections)
    }
    
    private func uploadProfilePic(profileImage: Data){
        self.viewDelegate?.showProgressIndicator(message: LoadingIndicatorMessages.updatingProfile)
        
        let imageUploadItem = UploadItem(data: profileImage, name: "myFile", fileName: "image.jpeg", mimeType: "image/jpeg")
        let profileApi = ProfileApi()
        profileApi.setCompletionHandler{data, error in
            
            
            if error == nil{
                self.updateUserProfile()
            }else{
                self.viewDelegate?.hideProgressIndicator()
                self.viewDelegate?.showErrorToastMessage(message: error?.errorMessage ?? ErrorMessages.genericError)
            }
        }
        profileApi.updateProfilePicture(userId: AppEngine.sharedInstance.userID, imageUploadItem: imageUploadItem)
    }
    func updateProfile(profileImage: Data?){
        if validatePofile(){
            self.viewDelegate?.showProgressIndicator(message: LoadingIndicatorMessages.updatingProfile)
            if profileImage == nil{
                updateUserProfile()
            }else{
                uploadProfilePic(profileImage: profileImage!)
            }
        }
         
    }
    private func updateUserProfile(){
        
        
            Log.i("Data Validated")
            let user = AppEngine.sharedInstance.userDetails!
           
            let request = ProfileUpdateRequest()
            request.requestBody = ProfileRequestInfo()
            request.userID = user.userID
            
            //moto
            request.requestBody?.raceNo = user.raceNo
            request.requestBody?.amaExpires = user.amaExpires
            request.requestBody?.ccsNo = user.ccsNo
            request.requestBody?.amaNo = user.amaNo
            request.requestBody?.asraNo = user.asraNo
            request.requestBody?.sponsors = user.sponsors
            request.requestBody?.nationality = user.nationality
            request.requestBody?.teamnames = user.teamnames
            
            request.requestBody?.firstName = user.firstName
            request.requestBody?.lastName = user.lastName
            request.requestBody?.email = user.email
            request.requestBody?.evGender = user.evGender
            request.requestBody?.evDob = user.evDob
            request.requestBody?.evRaceLicence = user.evRaceLicence
            
            request.requestBody?.evMotorcycle = user.evMotorcycle
            request.requestBody?.evMotorcycleNumber = user.evMotorcycleNumber
            
            request.requestBody?.everBeenTrack = user.everBeenTrack
            
            
            //Emergency Contact
            request.requestBody?.evEmergencyFirstName = user.evEmergencyFirstName
            request.requestBody?.evEmergencyLastName = user.evEmergencyLastName
            request.requestBody?.evEmergencyPhone = user.evEmergencyPhone
            request.requestBody?.evEmergencyRelationship = user.evEmergencyRelationship
            
            let profileApi = ProfileApi()
            profileApi.setCompletionHandler{data, error in
                
               
                if error == nil{
                    self.fetchUserDetails()
                }else{
                     self.viewDelegate?.hideProgressIndicator()
                    self.viewDelegate?.showErrorToastMessage(message: error?.errorMessage ?? ErrorMessages.genericError)
                }
            }
            profileApi.updateProfile(request: request)
            
            
        
    }
    func validatePofile() -> Bool{
        var isValid = false;
        if let user = AppEngine.sharedInstance.userDetails{
            if user.firstName?.isEmpty ?? true{
                self.profileViewDelegate?.validationError(message: ValidationErrors.emptyFirstName, section: .info)
            }else if user.lastName?.isEmpty ?? true{
                self.profileViewDelegate?.validationError(message: ValidationErrors.emptyLastName, section: .info)
            } else if user.email?.isEmpty ?? true{
                self.profileViewDelegate?.validationError(message: ValidationErrors.invalidEmail, section: .info)
            }else if user.evDob?.isEmpty ?? true{
                self.profileViewDelegate?.validationError(message: ValidationErrors.invalidDoB, section: .info)
            } else if user.evMotorcycle?.isEmpty ?? true{
                self.profileViewDelegate?.validationError(message: ValidationErrors.invalidMotorCycleName, section: .motorcycle)
            }else if user.evMotorcycleNumber?.isEmpty ?? true{
                self.profileViewDelegate?.validationError(message: ValidationErrors.invalidMotorCycleNumber, section: .motorcycle)
            }
                //Moto Gladiator
            else if user.raceNo?.isEmpty ?? true{
                self.profileViewDelegate?.validationError(message: ValidationErrors.invalidRaceNumber, section: .moto)
            }else if user.amaNo?.isEmpty ?? true{
                self.profileViewDelegate?.validationError(message: ValidationErrors.invalidAMANumber, section: .moto)
            } else if user.amaExpires?.isEmpty ?? true{
                self.profileViewDelegate?.validationError(message: ValidationErrors.amaExpiryRequired, section: .moto)
            } else if user.ccsNo?.isEmpty ?? true{
                self.profileViewDelegate?.validationError(message: ValidationErrors.invalidCCSNumber, section: .moto)
            } else if user.asraNo?.isEmpty ?? true{
                self.profileViewDelegate?.validationError(message: ValidationErrors.invalidASRANumber, section: .moto)
            }else if user.nationality?.isEmpty ?? true{
                self.profileViewDelegate?.validationError(message: ValidationErrors.invalidNationality, section: .moto)
            }else if user.sponsors?.isEmpty ?? true{
                self.profileViewDelegate?.validationError(message: ValidationErrors.sponsorRequired, section: .moto)
            }else if user.teamnames?.isEmpty ?? true{
                self.profileViewDelegate?.validationError(message: ValidationErrors.teammateRequired, section: .moto)
            }else if user.evEmergencyFirstName?.isEmpty ?? true{
                self.profileViewDelegate?.validationError(message: ValidationErrors.emptyFirstName, section: .emergency)
            }else if user.evEmergencyLastName?.isEmpty ?? true{
                self.profileViewDelegate?.validationError(message: ValidationErrors.emptyLastName, section: .emergency)
            }else if user.evEmergencyPhone?.isEmpty ?? true{
                self.profileViewDelegate?.validationError(message: ValidationErrors.invalidPhoneNumber, section: .emergency)
            }else if user.evEmergencyRelationship?.isEmpty ?? true{
                self.profileViewDelegate?.validationError(message: ValidationErrors.invalidRelationship, section: .emergency)
            }else{
                isValid = true;
            }
        }else{
            self.profileViewDelegate?.validationError(message: ErrorMessages.genericError, section: .info)
        }
        
        return isValid;
    }
    
    private func fetchUserDetails() {
        
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
            self.viewDelegate?.showSuccessToastMessage(message: SuccessMessages.profileUpdated)
        }
        profileApi.fetchUserDetails(userId: AppEngine.sharedInstance.userID)
    }
}
enum ProfileSections : Int, CaseIterable{
    case pic
    case info
    case motorcycle
    case mailingAddress
    case billingAddress
    case skillLevel
    case moto
    case emergency
}
