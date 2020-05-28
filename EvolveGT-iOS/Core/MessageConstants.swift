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
    
    static let externalLink = "Would you like to open this event in browser?"
    
    static let txtRaceLicenceRequired = """
<p>
      A race license is required to participate in Motogladiator racing. Please sign up for the Race Certification
      training prior to registering for any racing. Participation in a Mock race and rental transponder are
      included on the date you have training. You must be an intermediate or above group level rider to take the Race Certification
      Training.
    </p>

    <p>
      If you have prior race experience that you feel qualifies you to participate in the Motogladiator race
      series, please contact support at <a href="tel: 702-602-2770">702-602-2770</a>  or support@evolvegt.com.
</p>
"""
    
    
    
}

//Mark: - Indicator Messages
struct LoadingIndicatorMessages {
    static let loading = "Loading..."
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
    
    
    
    static let loadingEventDetails = "Loading event details..."
    static let loadingArchieCardList = "Loading archie cards..."
    
    static let loadingProducts = "Loading products..."
    static let loadingProductDetails = "Loading product details..."
    
    
    static let addingEventToCart = "Adding this event to cart..."
    static let addingProductToCart = "Adding this product to cart..."
    
    static let loadingCartList = "Loading your cart list..."
    static let deletingCartItem = "We are removing an item from your cart."
    
    static let uploadingSignature = "Please wait, We're saving your signature."
}

struct ErrorMessages {
    
    static let genericError = "Sorry, something went wrong, please try again in a couple minutes."
    static let emptyCompletedEvents = "Sorry, there are currently no events available."
    static let emptyEventParticipants = "There are currently no users enrolled for this event."
    static let emptyEnrolledEvents = "Sorry, no event has been found."
    static let emptyCreditHistory = "Sorry, You have no credit history."
    static let skillNotEligibleMessage = "GT1 and E1 are not eligible to participate in race."
    
    
    
    static let emptySearchParticipants = "Sorry, we couldn't find any user matching the search"
    static let signatureUploadError = "Sorry, Signature could not be saved."
    
    
    static let invalidEmail = "Please enter valid email"
    
    static let emptyCreditList = "Sorry, You have no credit history."
    
    static let emptyEventList = "Sorry, there is no events available right now."
    
    static let error_confirm_password = "Your password and confirmation password do not match."
    static let error_empty_password = "Please enter new password."
    static let error_empty_current_password = "Please enter your current password."
    
    
    static let emptyEventClass = "Please select at least one class"
    static let skillNotSelected = "Please select a skill set"
    static let transponderNotSelected = "Please select transponder or enter your transponder number"
    
    
    static let emptyProducts = "Unfortunately, there is no products available right now."
    static let emptyCartList = "Sorry, Your cart is empty."
    static let hasOutOfStockItems = "Please delete out of stock items from your cart to continue."
}

struct SuccessMessages {
    
    static let skillUpgraded = "Skill Level upgraded successfully"
    static let signatureSaved = "Your Signature has been saved."
    static let passwordChanged = "Your password has been changed successfully."
    
    static let eventAddedToCart = "Your event has been added to the cart successfully."
    static let productAddedToCart = "Your Product has been added to the cart successfully."
    
    static let latestVersion =  "The latest version is already installed."
    static let oldVersion = "New version available in store. Please update."
    static let cartItemDeleted = " Successfully deleted."
    
}

struct AlertTitle{
    static let raceLicenceRequired = "Race Licence is Required"
    static let skillNotEligible = "Skill Not Eligible"
    static let externalHost = "External Host"
}
