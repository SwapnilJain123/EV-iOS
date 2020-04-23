//
//  BaseViewDelegate.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 22/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
protocol BaseViewDelegate {
    
    func showProgressIndicator(message : String?)
    func hideProgressIndicator()
    func showError(message: String)
   
}
