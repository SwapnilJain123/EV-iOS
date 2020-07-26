//
//  ETViewController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 22/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit
import RSSelectionMenu
class ETViewController : UIViewController{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ext.setNavigationBackgroundColor(color: UIColor.getAppThemeColor())
        
        self.ext.setScreenTitle(title: getScreenTitle() ?? "")
        self.ext.hideErrorView()
       
    }
    func createMoreButton() -> UIBarButtonItem{
       
        let moreButton = UIBarButtonItem.menuButton(self, action: #selector(self.didPressMoreButton), imageName: "three_dots")
            
        return moreButton
    }
    
    @objc func didPressMoreButton(){
        Log.d("More Button tapped")
    }
    func registerForKeyboard(constraint : NSLayoutConstraint) {
         NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(constraint:notification:)),
                                                name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
   
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @objc func keyboardNotification(constraint : NSLayoutConstraint?, notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if endFrameY >= UIScreen.main.bounds.size.height {
                constraint?.constant = 0.0
            } else {
                constraint?.constant = endFrame?.size.height ?? 0.0
            }
            UIView.animate(withDuration: duration,
                                       delay: TimeInterval(0),
                                       options: animationCurve,
                                       animations: { self.view.layoutIfNeeded() },
                                       completion: nil)
        }
    }
    
    func getScreenTitle() ->String?{
        nil
    }
    
    
    
    func presentSelectionMenu( title: String, data: [String], dismissHandler :@escaping (_ selectedItems: DataSource<String>) -> Void){
        let selectionMenu = RSSelectionMenu(dataSource: data) { (cell, item, indexPath) in
            cell.textLabel?.text = item
        }
        
        selectionMenu.onDismiss = dismissHandler
        selectionMenu.maxSelectionLimit = 1
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.title = title
        selectionMenu.tableView?.accessibilityIdentifier = "SelectionMenuTableView"
        
        selectionMenu.show(style: .present, from: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.ext.removeLoadingIndicatorImmediately()
        super.viewWillDisappear(animated)
        self.ext.showNavbar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.ext.setNavigationBackgroundColor(color: .getAppThemeColor())
    }
}

extension ETViewController: BaseViewDelegate{
    @objc func showSuccessToastMessage(message: String) {
        self.ext.showSuccessToast(message: message, handler: nil)
    }
    
    @objc func showErrorToastMessage(message: String) {
        self.ext.showErrorToast(message: message, handler: nil)
    }
    @objc  
    func showProgressIndicator(message: String?) {
        self.ext.addLoadingIndicator(message)
    }
    
    @objc func hideProgressIndicator() {
        self.ext.removeLoadingIndicator()
    }
    @objc  
    func showEmptyPageError(message: String) {
        self.ext.displayEmptyMessage(message: message)
    }
    
    @objc func showAlert(title: String, message: String) {
        self.ext.showAlert(title: title, message: message)
    }
    
    @objc func hideEmptyPageError() {
           self.ext.hideErrorView()
    }
    
    @objc func updateCartBadge(count: Int) {
        if let tabbarVC = self.navigationController?.tabBarController as? ETTabViewController{
            tabbarVC.updateCartBadgeCount(count: count)
            Log.i("Updating Badge - \(count)")
        }else{
            Log.i("Updating Badge request failed - \(count)")
        }
    }
}

extension UIViewController{
    @objc func didPressLogout(){
        self.dashboardManager.logout()
    }
    
     
    /*
     Override this method to handle app theme switch functionality
     */
    @objc  func didChangeAppTheme(){
       
    }
    
}
