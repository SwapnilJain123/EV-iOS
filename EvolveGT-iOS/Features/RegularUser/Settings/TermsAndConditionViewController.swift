//
//  TermsAndConditionViewController.swift
//  EvolveGT-iOS
//
//  Created by Sonali Nagde on 24/03/24.
//  Copyright © 2024 YaraTech. All rights reserved.
//

import UIKit
import WebKit

class TermsAndConditionViewController: ETViewController {
    @IBOutlet weak var webView: WKWebView!
    
    var url: String?
    var screenTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUrl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.ext.showNavbar()
        self.ext.showBackButton()
    }
    
    override func getScreenTitle() -> String? {
        self.screenTitle
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.ext.hideNavbar()
    }
    
    private func loadUrl() {
        let urlString = "\(ApiConstants.BASE_URL)\(url!)"
        if let url = URL(string: urlString) {
            self.webView.load(URLRequest.init(url: url))
        }
    }
}
