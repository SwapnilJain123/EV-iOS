//
//  ViewControllerExtension.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 22/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

extension UIViewController{
    func showAlert(title: String?, message: String?) {
        let alerController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alerController.addAction(cancelAction)
        present(alerController, animated: true, completion: nil)
    }
    func addLoadingIndicator(){
        DispatchQueue.main.async(execute: { () -> Void in
            MBProgressHUD.showAdded(to: self.view, animated: true)

        })
    }

    func removeLoadingIndicator(){
        MBProgressHUD.hide(for: self.view, animated: true)
    }
}
