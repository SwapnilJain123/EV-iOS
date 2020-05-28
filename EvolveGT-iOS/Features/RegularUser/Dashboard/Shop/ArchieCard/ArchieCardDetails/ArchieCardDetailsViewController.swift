//
//  ArchieCardDetailsViewController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 28/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import UIKit

class ArchieCardDetailsViewController: ETViewController,ArchieCardDetailsDelegate {
    func didFetchArchieCardDetails(archieCardDetails: ArchieCardDetails) {
        
        Log.d("got archieCard details")
        
    }
    
    var slug = ""
    var selectedArchieTitle = ""
    var archieCardInteractor = ArchieCardInteractor()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        archieCardInteractor.archieCardDetailsDelegate = self
        archieCardInteractor.viewDelegate = self
        
        archieCardInteractor.getArchieCardDetails(slug: slug)
        
        
        
        

       
    }
    override func getScreenTitle() -> String? {
        selectedArchieTitle.capitalized
    }
    
}
