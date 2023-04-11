//
//  E-WaiverViewController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 02/09/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import UIKit


class EWaiverViewController: ETViewController, WaiverListDelegate , WaiverCellDelegate{
    func showWaiverDetailsPage(waiver: EWaiver) {
        self.eventId = waiver.eventID ?? ""
         let VC = self.ext.getViewController(storyBoard: "E-Waiver", VCIdentifier: "WaiverDeatailsVC") as! EWaiverDetailsViewController
        VC.eventID = self.eventId
        self.ext.pushViewController(viewController: VC)
        
    }
    
    var eventId = ""
    func waiverListFetched(waiverEvents: [EWaiver]) {
        self.eWaiverlist = waiverEvents
        
        wavierTableView.reloadData()
    }
    
    
    var eWaiverlist = [EWaiver]()
    @IBOutlet weak var wavierTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        wavierTableView.delegate = self
        wavierTableView.dataSource = self
        let interactor = EWaiverInteractor()
        interactor.waiverDelegate = self
        interactor.delegate = self
        
        
        interactor.getEWaiverList()
        

       
    }
    override func getScreenTitle() -> String? {
        ScreenTitle.TITLE_WAIVER
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
   

}

extension EWaiverViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eWaiverlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "E-WaiverVC", for: indexPath) as! WavierCell
        let waiver = eWaiverlist[indexPath.row]
        cell.detailsDelegate = self
        cell.showData(waiver:waiver)
        return cell
    }
    
    
}




