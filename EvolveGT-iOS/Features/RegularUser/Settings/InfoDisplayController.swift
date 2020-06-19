//
//  TextDisplayController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 18/06/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit

class InfoDisplayController : ETViewController{
    @IBOutlet weak var contentText: UITextView!
    
    var text = ""
    var contentTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentText.attributedText = text.toAttributedText(with: 16.0)
    }
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           self.ext.showNavbar()
           self.ext.showBackButton()
           
       }
       
       override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           self.ext.hideNavbar()
       }
       
       override func getScreenTitle() -> String? {
           contentTitle
       }
}
