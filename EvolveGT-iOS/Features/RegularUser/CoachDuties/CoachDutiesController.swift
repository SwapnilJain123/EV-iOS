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
    
    
    @IBOutlet weak var dutyTabs: UISegmentedControl!
    @IBOutlet weak var lblEventName: UILabel!
    @IBOutlet weak var lblEventDate: UILabel!
    
    @IBOutlet weak var lblHostedBy: UILabel!
    @IBOutlet weak var dutyListView: UICollectionView!
    var assignedDuty: AssignedDuty?
    
    
    var hasPastEvents = false
    var hasCurrentEvents = false
    var hasUpcomingEvents = false
    
    override func getScreenTitle() -> String? {
        ScreenTitle.TITLE_COACH_DUTIES
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sortDuties()
        setEmptyFlags()
        
        
        dutyListView.dataSource = self
        dutyListView.delegate = self
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // lblEventName.textColor = .getAppThemeColor()
        dutyListView.reloadData()
    }
    
    func sortDuties(){
        if assignedDuty?.past?.count ?? 0 > 0{
            for event in assignedDuty!.past!{
                let sortedDuties = event.duties?.sorted(by: { duty1,duty2 in (duty1.status ?? false) })
                event.duties = sortedDuties
            }
        }
        
        if assignedDuty?.current?.count ?? 0 > 0{
            for event in assignedDuty!.current!{
                let sortedDuties = event.duties?.sorted(by: { duty1,duty2 in (duty1.status ?? false) })
                event.duties = sortedDuties
            }
        }
        
        
        if assignedDuty?.upcoming?.count ?? 0 > 0{
            for event in assignedDuty!.upcoming!{
                let sortedDuties = event.duties?.sorted(by: { duty1,duty2 in (duty1.status ?? false) })
                event.duties = sortedDuties
            }
        }
    }
    
    func setEmptyFlags(){
        hasPastEvents = assignedDuty?.past?.count ?? 0 > 0
        hasCurrentEvents = assignedDuty?.current?.count ?? 0 > 0
        hasUpcomingEvents = assignedDuty?.upcoming?.count ?? 0 > 0
        
    }
    
    @IBAction func dutyTabChanged(_ sender: UISegmentedControl) {
        var isEmpty = false
        switch dutyTabs.selectedSegmentIndex {
            case 0:
                isEmpty = !hasPastEvents
            case 1:
                isEmpty = !hasCurrentEvents
            case 2:
                isEmpty = !hasUpcomingEvents
            default:
                isEmpty = true
        }
        if (isEmpty) {
            self.dutyListView.setEmptyMessage("No assigned duties.")
        } else {
            self.dutyListView.restore()
            
        }
        dutyListView.reloadData()
    }
        
    }
    extension CoachDutiesController: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
        
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            switch dutyTabs.selectedSegmentIndex {
            case 0:
                return assignedDuty?.past?.count ?? 0
            case 1:
                return assignedDuty?.current?.count ?? 0
            case 2:
                return assignedDuty?.upcoming?.count ?? 0
            default:
                return  0
            }
        }
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            
            var count = 0
            var isEmpty = true
            switch dutyTabs.selectedSegmentIndex {
            case 0:
                count = assignedDuty?.past?[section].duties?.count ?? 0
                isEmpty = !hasPastEvents
            case 1:
                count = assignedDuty?.current?[section].duties?.count ?? 0
                isEmpty = !hasCurrentEvents
            case 2:
                count = assignedDuty?.upcoming?[section].duties?.count ?? 0
                isEmpty = !hasUpcomingEvents
            default:
                count =  0
            }
            
            if (isEmpty) {
                self.dutyListView.setEmptyMessage("No assigned duties.")
            } else {
                self.dutyListView.restore()
            }
            return count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DutyCell.identifier, for: indexPath) as! DutyCell
            
            var duty = Duty()
            switch dutyTabs.selectedSegmentIndex {
            case 0:
                duty = assignedDuty!.past![indexPath.section].duties![indexPath.row]
            case 1:
                duty = assignedDuty!.current![indexPath.section].duties![indexPath.row]
            case 2:
                duty = assignedDuty!.upcoming![indexPath.section].duties![indexPath.row]
                
            default:
                duty = Duty()
            }
            
            
            
            cell.setData(duty: duty)
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
        func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            
            if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as? DutyEventHeader{
                var event = EventDuty()
                switch dutyTabs.selectedSegmentIndex {
                case 0:
                    event = assignedDuty!.past![indexPath.section]
                case 1:
                    event = assignedDuty!.current![indexPath.section]
                case 2:
                    event = assignedDuty!.upcoming![indexPath.section]
                    
                default:
                    event = EventDuty()
                }
                sectionHeader.updateHeader(event: event.event ?? "", date: event.eventDate ?? "", eventType: event.eventType ?? "")
                return sectionHeader
            }
            return UICollectionReusableView()
        }
    }
    
    class DutyEventHeader: UICollectionReusableView{
        
        @IBOutlet weak var eventDate: UILabel!
        @IBOutlet weak var eventName: UILabel!
        
        @IBOutlet weak var hostedBy: UILabel!
        
        func updateHeader(event: String, date: String, eventType: String){
            eventName.text = "Event: \(event)"
            eventDate.text = "Date: \(date.formattedDate(inputPattern: .FORMAT_YYYY_MM_DD_HIPHEN, outputFormat: .FORMAT_DD_MMM_YYYY))"
            hostedBy.text = "Hosted By: \(eventType)"
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
