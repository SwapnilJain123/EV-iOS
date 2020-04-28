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
        self.setNavigationBackgroundColor(color: UIColor.init(hexFromString: UIColor.COLOR_EV))
        
        self.setScreenTitle(title: getScreenTitle() ?? "")
    
    }
    @objc func logout(){
        
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
    
    @objc func didPressLogout(){
        Log.d("Logout !!")
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.doLogout()
    }
    
    func presentSelectionMenu( title: String, data: [String], dismissHandler :@escaping (_ selectedItems: DataSource<String>) -> Void){
        let selectionMenu = RSSelectionMenu(dataSource: data) { (cell, item, indexPath) in
            cell.textLabel?.text = item
        }
        
        selectionMenu.onDismiss = dismissHandler
        selectionMenu.maxSelectionLimit = 1
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.title = title
        
        selectionMenu.show(style: .present, from: self)
    }
}
