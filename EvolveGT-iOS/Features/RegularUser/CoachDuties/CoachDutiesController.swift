//
//  CoachDutiesController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 13/06/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit

class CoachDutiesController: ETViewController{
    @IBOutlet weak var lblEventName: UILabel!
    @IBOutlet weak var lblEventDate: UILabel!
    
    @IBOutlet weak var lblHostedBy: UILabel!
    @IBOutlet weak var dutyListView: UICollectionView!
    var assignedEvent: AssignedEvent?
    
    
    override func getScreenTitle() -> String? {
        ScreenTitle.TITLE_COACH_DUTIES
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sortedDuties = assignedEvent?.duties?.sorted(by: { duty1,duty2 in (duty1.status ?? false) })
        assignedEvent?.duties = sortedDuties
        dutyListView.dataSource = self
        dutyListView.delegate = self
        
       
        lblEventName.text = "Event: \(assignedEvent?.event ?? "")"
        lblEventDate.text = "Date: \(assignedEvent?.eventDate?.formattedDate(inputPattern: .FORMAT_YYYY_MM_DD_HIPHEN, outputFormat: .FORMAT_DD_MMM_YYYY) ?? "")"
        lblHostedBy.text = "Hosted By: \(assignedEvent?.eventType ?? "")"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         lblEventName.textColor = .getAppThemeColor()
        dutyListView.reloadData()
    }
}
extension CoachDutiesController: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.assignedEvent?.duties?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DutyCell.identifier, for: indexPath) as! DutyCell
        cell.setData(duty: assignedEvent!.duties![indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let height = CGFloat(30.0)
        var width = (collectionView.frame.size.width/2) - 20
        
        if DeviceType.IS_IPAD{
            width = (collectionView.frame.size.width/3) - 12
        }
        return CGSize(width: width, height:height)
    }
    
}
class DutyCell: UICollectionViewCell{
    static let identifier = "DutyCell"

    @IBOutlet weak var sutyStatusIcon: UIImageView!
    
    @IBOutlet weak var dutyTitle: UILabel!
    
    
    func setData(duty: Duty){
        dutyTitle.text = duty.duty
        if duty.status ?? false{
            if AppEngine.sharedInstance.isEvApp(){
                sutyStatusIcon.image = UIImage(named: "ic_evolve_tik")
            }else{
                sutyStatusIcon.image = UIImage(named: "ic_moto_tik")
            }
        }else{
            sutyStatusIcon.image = UIImage(named: "ic_not_assigned")
        }
    }
}
