//
//  HomeViewController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 04/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController: ETViewController{
    
    @IBOutlet weak var prifileView: UITableView!
    var profileData : ProfileData? = nil
    
    let interactor = HomeDataInteractor()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prifileView.rowHeight = UITableView.automaticDimension
        prifileView.estimatedRowHeight = 300
        
        interactor.delegate = self
        interactor.fetchUserDetails()
        
    }
    
    override func getScreenTitle() -> String? {
        ScreenTitle.TITLE_DASHBOARD
    }
}

extension HomeViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Log.d("Profile Data - \(self.profileData == nil)")
        return self.profileData == nil ? 0 : 4
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.row == 0 {
            let profileCell = tableView.dequeueReusableCell(withIdentifier:"HomeProfileCell",for: indexPath) as! ProfileCell
            
            profileCell.showData(self.profileData!)
            return profileCell;
        }else if indexPath.row == 1 {
            
            if self.profileData?.recentUpComingEvent == nil{
                let emptyInfoCell = tableView.dequeueReusableCell(withIdentifier:"HomeEmptyCell",for: indexPath) as! EmptyCell
                Log.d("Empty Cell")
                emptyInfoCell.showData(ScreenTitle.TITLE_UPCOMING_EVENTS, ErrorMessages.emptyEnrolledEvents)
                return emptyInfoCell
            }else{
                let upComingEventCell = tableView.dequeueReusableCell(withIdentifier:"EventCell",for: indexPath) as! EventInfoCell
                
                upComingEventCell.populateViews(type: .UPCOMING, profileData!.recentUpComingEvent!)
                return upComingEventCell;
            }
            
        }else if indexPath.row == 2 {
            
            if self.profileData?.recentPastEvent == nil{
                let emptyInfoCell = tableView.dequeueReusableCell(withIdentifier:"HomeEmptyCell",for: indexPath) as! EmptyCell
                emptyInfoCell.showData(ScreenTitle.TITLE_PAST_EVENTS, ErrorMessages.emptyEnrolledEvents)
                return emptyInfoCell
            }else{
                let pastEventCell = tableView.dequeueReusableCell(withIdentifier:"EventCell",for: indexPath) as! EventInfoCell
                
                pastEventCell.populateViews(type: .PAST, profileData!.recentPastEvent!)
                return pastEventCell;
            }
            
           
        }else if indexPath.row == 3 {
            
            if self.profileData?.recentCreditHistory == nil{
                let emptyInfoCell = tableView.dequeueReusableCell(withIdentifier:"HomeEmptyCell",for: indexPath) as! EmptyCell
                emptyInfoCell.showData(ScreenTitle.TITLE_CREDIT_HISTORY, ErrorMessages.emptyEnrolledEvents)
                return emptyInfoCell
            }else{
                let creditCell = tableView.dequeueReusableCell(withIdentifier:"RecentCreditCell",for: indexPath) as! CreditHistoryCell
                
                creditCell.showData(profileData!.recentCreditHistory!)
                return creditCell;
            }
            
           
        }else {
            let emptyInfoCell = tableView.dequeueReusableCell(withIdentifier:"HomeEmptyCell",for: indexPath)
            Log.d("Empty Cell")
            return emptyInfoCell
        }
        
        
    }
    

    
}

extension HomeViewController: HomeViewDelegate{
    func didFetchDetails(profileData: ProfileData?) {
        
        Log.d("Profile Data Fetched")
        self.profileData = profileData
        prifileView.reloadData()
    }
    
    
    
    
}
