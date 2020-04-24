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
    
    static let ERROR_VIEW_TAG = -1
    func displayEmptyMessage(message: String){
        
        if let existingView = self.view.viewWithTag(UIViewController.ERROR_VIEW_TAG){
            existingView.removeFromSuperview()
        }
        
        let errorView: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        errorView.text          = message
        errorView.numberOfLines = 0
        errorView.tag = UIViewController.ERROR_VIEW_TAG
        errorView.backgroundColor = UIColor.init(hexFromString: "#F9FAF7")
        errorView.textColor     = UIColor.black
        errorView.textAlignment = .center
        self.view.addSubview(errorView)
        
        
    }
}
