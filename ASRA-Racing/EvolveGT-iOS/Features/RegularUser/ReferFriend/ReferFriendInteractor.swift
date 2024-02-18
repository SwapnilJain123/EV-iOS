//
//  ReferFriendInteractor.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 20/09/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
class ReferFriendInteractor:BaseInteractor{
    func ReferFriend(userID: Int , email:String){
        delegate?.showProgressIndicator(message: LoadingIndicatorMessages.inviteFriend)
        let api = WaiverApi()
        api.setCompletionHandler{ data , error in
            self.delegate?.hideProgressIndicator()
            if error == nil{
                self.delegate?.showAlert(title: "Invitation sent", message: SuccessMessages.InvitationSent)
            }else{
                self.delegate?.showErrorToastMessage(message: ErrorMessages.genericError)
            }
            
        }
        var request = ReferFriendRequest()
        request.userID = AppEngine.sharedInstance.userID
        request.friendEmail = email
        api.ReferFriend(referFriendRequest: request)
    }
}
