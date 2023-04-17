//
//  BaseViewDelegate.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 22/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
@objc protocol BaseViewDelegate {
    
    func showProgressIndicator(message : String?)
    func hideProgressIndicator()
    func showEmptyPageError(message: String)
    func hideEmptyPageError()
    func showSuccessToastMessage(message: String)
    func showErrorToastMessage(message: String)
    func showAlert(title: String, message: String)
    func updateCartBadge(count: Int)
   
}
