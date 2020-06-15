//
//  MessageConstants.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 22/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
struct MessageConstants {
    
   
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

struct ValidationErrors{
    static let emptyFirstName = "Please provide first name"
    static let emptyLastName = "Please provide last name"
    static let invalidPhoneNumber = "Please provide a valid phone number"
    static let invalidEmail = "Please provide a valid email"
    static let invalidDoB = "Please select date of birth"
    static let invalidMotorCycleName = "Please provide a valid motorcycle name"
    static let invalidMotorCycleNumber = "Please provide a valid motorcycle number"
    static let invalidRelationship = "Please select the relationship"
    static let invalidRaceNumber = "Please provide a valid race number"
    static let invalidAMANumber = "Please provide a valid AMA number"
    static let invalidASRANumber = "Please provide a valid ASRA number"
    static let invalidCCSNumber = "Please provide a valid CCS number"
    static let invalidNationality = "Please provide your nationality"
    static let teammateRequired = "Please provide at least one team mate"
    static let sponsorRequired = "Please provide at least one sponsor"
    static let amaExpiryRequired = "Please select your AMA expiry date"
    static let mailingAddressRequired = "No mailing address found. Please add a new address"
    static let billingAddressRequired = "No billing address found. Please add a new address"
     static let countryRequired = "Please select your country"
     static let stateRequired = "Please select your state"
    static let cityRequired = "Please provide your city"
     static let addressRequired = "Please provide your address"
    static let postalCodeRequired = "Please provide your postal code"
}

//Mark: - Indicator Messages
struct LoadingIndicatorMessages {
    static let loading = "Loading..."
    static let loggingIn = "Logging in..."
    static let loggingOut = "Logging out..."
    static let loadingCompletedEvents = "Loading events..."
    static let loadingParticipants = "Loading participants..."
    static let loadingSignature = "Loading Signature..."
     static let loadingMembershipList = "Loading available membership packages..."
    
    static let loadingEvents = "Loading Events..."
    
    static let loadingProfileData = "Loading Profile..."
    static let loadingCreditHistory = "Loading your credit history..."
    static let loadingEventHistory = "Loading your event history..."
    static let resettingPassword = "Resetting your password..."
    
    static let loadingEventDetails = "Loading event details..."
    static let loadingArchieCardList = "Loading archie cards..."
     static let loadingArchieCardDetails = "Loading archie cards details..."
    static let addingArchieCardToCart = "Adding Archie Card to cart..."
    static let loadingGiftCardList = "Loading Gift cards..."
     static let loadingGiftCardDetails = "Loading gift cards details..."
     
    static let addingGiftCardToCart = "Adding Gift Card to cart..."
    static let loadingProducts = "Loading products..."
    static let loadingProductDetails = "Loading product details..."
    
    
    static let addingEventToCart = "Adding this event to cart..."
    static let addingProductToCart = "Adding this product to cart..."
    
    static let loadingCartList = "Loading your cart list..."
    static let deletingCartItem = "We are removing an item from your cart."
    static let validatingCoupon = "We're currently validating your coupon code, please wait..."
    
    static let uploadingSignature = "Please wait, We're saving your signature."
    static let placingOrder = "Please wait, Placing your order..."
    
     static let cancellingEvent = "Please wait, we are cancelling your event"
    static let addingMembershipToCart = "Adding this membership to cart..."
       static let loadingMembershipDetails = "Loading Membership details..."
    static let updatingProfile = "Please wait, we are updating your profile"
     static let updatingBillingAdress = "Please wait, we are updating your billing address"
    static let updatingShippingAdress = "Please wait, we are updating your shipping address"
    static let loadingCoachDuties = "Loading duties assigned to you."
     static let savingAgreement = "Saving policy agreement..."
    
     static let readingPrefernces = "Please wait, reading your preferences..."
    
}

struct ErrorMessages {
    
    static let genericError = "Sorry, something went wrong, please try again in a couple minutes."
    
    static let skillNotEligibleMessage = "GT1 and E1 are not eligible to participate in race."
    
    static let invalidCoupon = "Please enter a valid coupon"
    
    static let emptySearchParticipants = "Sorry, we couldn't find any user matching the search"
    static let signatureUploadError = "Sorry, Signature could not be saved."
    static let invalidEmail = "Please enter valid email"
     static let emptyReceiverName = "Please enter receiver name"
    static let emptyReceiverEmail = "Please enter receiver email"

    static let errorConfirmPassword = "Your password and confirmation password do not match."
    static let errorEmptyPassword = "Please enter new password."
    static let errorEmptyCurrentPassword = "Please enter your current password."
    
    static let skillNotSelected = "Please select a skill set"
    static let transponderNotSelected = "Please select transponder or enter your transponder number"
    
    static let hasOutOfStockItems = "Please delete out of stock items from your cart to continue."
    
    static let checkoutNoBillingAddress = "Unfortunately, no billing address has been found. Please add your billing address."
    
    //Mark:- Empty Items
    static let emptyCompletedEvents = "Sorry, there are currently no events available."
    static let emptyEventParticipants = "There are currently no users enrolled for this event."
    static let emptyEnrolledEvents = "Sorry, no event has been found."
    static let emptyCreditHistory = "Sorry, You have no credit history."
    static let emptyCreditList = "Sorry, You have no credit history."
    static let emptyEventList = "Sorry, there is no events available right now."
    static let emptyEventClass = "Please select at least one class"
    static let emptyProducts = "Unfortunately, there is no products available right now."
    static let emptyCartList = "Sorry, Your cart is empty."
    static let emptyArchieCards = "There are no Archie Cards available right now."
    static let emptyGiftCards = "There are no Gift Cards available."
    
    
     static let eventsNotAssigned = "Sorry. There are no events assigned to you."
    static let paypalTokenError = "Sorry, paypal payment service is not available now. Please try again later."
     static let emptyMemberships = "Unfortunately, there is no memberships available right now."
    static let updatingPreferenceFailed = "Your notification preferences could not be updated."
}


struct SuccessMessages {
    
    static let skillUpgraded = "Skill Level upgraded successfully"
    static let signatureSaved = "Your Signature has been saved."
    static let passwordChanged = "Your password has been changed successfully."
    
    static let eventAddedToCart = "Your event has been added to the cart successfully."
    static let productAddedToCart = "Your Product has been added to the cart successfully."
    static let archieCardtAddedToCart = "Your Archie Card has been added to the cart successfully."
    static let giftCardtAddedToCart = "Your Gift Card has been added to the cart successfully."
    
    static let latestVersion =  "The latest version is already installed."
    static let oldVersion = "New version available in store. Please update."
    static let cartItemDeleted = "Successfully deleted."
    static let eventCancelled = "Event Cancelled successfully."
     static let membershipAddedToCart = "Your membership has been added to the cart successfully."
    
    static let profileUpdated = "Profile updated successfully."
     static let billingAdressUpdated = "Billing address updated successfully."
    static let preferencesUpdated = "Your notification preferences updated."
    
    
}

struct AlertTitle{
    static let raceLicenceRequired = "Race Licence is Required"
    static let skillNotEligible = "Skill Not Eligible"
    static let externalHost = "External Host"
}
