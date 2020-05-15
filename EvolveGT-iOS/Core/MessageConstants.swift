//
//  MessageConstants.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 22/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
struct MessageConstants {
    
    
    static let KPromptSomeThingWentWrong = "Something went wrong"
    
    static let KPromptMsgEnterWishlistName = "Please Enter Wishlist Name"
    static let KPromptMsgEnterEmployeeCode = "Please Enter Employee Code"
    static let KPromptMsgEnterAreaCode = "Please Enter Area Code"
    static let KPromptMsgEnterAreaName = "Please Enter Area Name"
    static let KPromptMsgEnterAreaManagerName = "Please Enter Area Manager Name"
    
    static let KPromptMsgEnterEmail = "Please Enter Email"
    static let KPromptMsgEnterValidEmail = "Please Enter Valid Email"
    static let KPromptMsgEnterPassword = "Please Enter Password"
    static let KPromptMsgEnterAddress = "Please Enter Address"
    static let KPromptMsgEnterCity = "Please Enter City"
    static let KPromptMsgEnterCountry = "Please Enter Country"
    static let KPromptMsgEnterZipcode = "Please Enter Zipcode"
    static let KPromptMsgEnterFirstName = "Please Enter First Name"
    static let KPromptMsgEnterLastName = "Please Enter Last Name"
    static let KPromptMsgEnterLandmark = "Please Enter Landmark"
    static let KPromptMsgEnterState = "Please Enter State"
    
    static let KPromptMsgEnterMobileNumber = "Please Enter Mobile Number"
    
    static let KPromptMsgSelectVendorReview = "Please Fill All the feilds"
    
    static let KPromptMsgEnterMessage = "Please enter the message"
    static let KPromptServerConectError = "Server connection error"
    
    
    
    
    
    
    
}

//Mark: - Indicator Messages
struct LoadingIndicatorMessages {
    
    static let loggingIn = "Logging in..."
        static let loggingOut = "Logging out..."
    static let loadingCompletedEvents = "Loading events..."
    static let loadingParticipants = "Loading participants..."
    static let loadingSignature = "Loading Signature..."
    
    static let loadingEvents = "Loading Events..."
    
    static let loadingProfileData = "Loading Profile..."
    static let loadingCreditHistory = "Loading your credit history..."
      static let loadingEventHistory = "Loading your event history..."
    static let resettingPassword = "Resetting your password..."
    
    static let addingEventToCart = "Adding this event to cart..."
    
    
    
    static let uploadingSignature = "Please wait, We're saving your signature."
}

struct ErrorMessages {
    
    static let genericError = "Sorry, something went wrong, please try again in a couple minutes."
    static let emptyCompletedEvents = "Sorry, there are currently no events available."
    static let emptyEventParticipants = "There are currently no users enrolled for this event."
    static let emptyEnrolledEvents = "Sorry, no event has been found."
     static let emptyCreditHistory = "Sorry, You have no credit history."
    
   
    
    static let emptySearchParticipants = "Sorry, we couldn't find any user matching the search"
    static let signatureUploadError = "Sorry, Signature could not be saved."
    

    static let invalidEmail = "Please enter valid email"

    static let emptyCreditList = "Sorry, You have no credit history."
    
    static let emptyEventList = "Sorry, there is no events available right now."
}

struct SuccessMessages {
    
    static let skillUpgraded = "Skill Level upgraded successfully"
    static let signatureSaved = "Your Signature has been saved."
    
    static let eventAddedToCart = "Your event has been added to the cart successfully."
    
}
