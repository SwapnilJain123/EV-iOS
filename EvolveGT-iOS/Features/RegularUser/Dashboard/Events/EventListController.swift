//
//  EventListController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 11/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit

enum DisplayMode : Int{
    case LIST
    case GRID
}
class EventListController : TabbedViewController{
    
    @IBOutlet weak var eventsListView: UICollectionView!
    
    var displayModeButton : UIButton!
    
    var displayMode: DisplayMode = .LIST
    let interactor = EventsInteractor()
    
    var events : [Event]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        eventsListView.delegate = self
        eventsListView.dataSource = self
        
        interactor.eventListDelegate = self
        interactor.fetchEventList()
        
    }
    
    override func addNavBarControls() -> [UIBarButtonItem]? {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "filter"), for: UIControl.State.normal)
        button.addTarget(self, action:#selector(self.didPressFilterOption) , for: .touchUpInside)
        button.frame =  CGRect.init(x: 0, y: 0, width: 45, height: 45)
        let barButton = UIBarButtonItem(customView: button)
        
        displayModeButton = UIButton(type: UIButton.ButtonType.custom)
        if displayMode == .LIST{
            displayModeButton.setImage(UIImage(named: "grid_view"), for: .normal)
        }else{
            displayModeButton.setImage(UIImage(named: "list_view"), for:.normal)
        }
        displayModeButton.addTarget(self, action:#selector(self.didChangeDisplayMode) , for: .touchUpInside)
        displayModeButton.frame =  CGRect.init(x: 0, y: 0, width: 45, height: 45)
        let gridBarButton = UIBarButtonItem(customView: displayModeButton)
        return  [gridBarButton,barButton]
    }
    
    @objc func didChangeDisplayMode(){
        
        displayMode = displayMode == DisplayMode.LIST ? .GRID : .LIST
        if displayMode == .GRID{
            displayModeButton.setImage(UIImage(named: "list_view"), for: .normal)
        }else{
            displayModeButton.setImage(UIImage(named: "grid_view"), for:.normal)
        }
        
        eventsListView.reloadData()
        
    }
    @objc func didPressFilterOption(){
        if events?.count ?? 0 > 0{
            showFilterOptions()
        }
    }
    override func getScreenTitle() -> String? {
        ScreenTitle.TITLE_EVENTS
    }
    
    override func didChangeAppTheme() {
        super.didChangeAppTheme()
        events?.removeAll()
        eventsListView.reloadData()
        interactor.fetchEventList()
    }
    
}

extension EventListController: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        events?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if displayMode == .GRID{
            let event = events![indexPath.row]
            let reusableIdentifier = interactor.shouldEnableAddToCart(event: event) ? "EventGridCellWithCart" : "EventGridCell"
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableIdentifier, for: indexPath as IndexPath) as! EventGridCell
            cell.event = event
            cell.delegate = self
            return cell
        }else{
            let event = events![indexPath.row]
            let reusableIdentifier = interactor.shouldEnableAddToCart(event: event) ? "EventListCellWithCart" : "EventListCell"
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableIdentifier, for: indexPath as IndexPath) as! EventListCell
            cell.event = event
             cell.delegate = self
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if displayMode == .GRID{
            let width = (collectionView.frame.size.width/2) - 5
            return CGSize(width: width, height: 260.0)
        }else{
            let heightOffset = events![indexPath.row].eventType?.count ?? 0 > 15 ? 14.0 : 0.0
            let height = CGFloat(150.0 + heightOffset)
            let width = (collectionView.frame.size.width) - 5
            return CGSize(width: width, height:height)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        self.ext.pushViewController(storyBoard: "Events", VCIdentifier: "EventDetailsVC")
        Log.d("Event Selected - \(events?[indexPath.row].title ?? "")")
    }
}

extension EventListController: EventListViewDelegate{
    func presentEventTypeFilterOptions(options: [String]) {
           let title = "Filter by Event Type"
           
           presentSelectionMenu(title: title, data: options){
               [weak self] selectedItems in
               let selectedTraining = selectedItems.first ?? ""
            self!.interactor.filterBy(selectedTraining, .eventType)
           }
       }
       
       func presentMonthFilterOptions(options: [String]) {
           let title = "Filter by Month"
           
           presentSelectionMenu(title: title, data: options){
               [weak self] selectedItems in
               let selectedTraining = selectedItems.first ?? ""
               self!.interactor.filterBy(selectedTraining, .month)
           }
       }
    
    func didFetchEvents(events: [Event]?) {
        self.events = events
        eventsListView.reloadData()
    }
    
    
}
extension EventListController{
    func showFilterOptions(){
        let filterActionSheet = UIAlertController(title: "Select filter", message: "", preferredStyle: .alert)
        let month         = UIAlertAction(title: "By Month", style: .default, handler: { _ in
            self.interactor.filterItems(with: .month)
        })
        let eventType     = UIAlertAction(title: "By Event Type", style: .default, handler: { _ in
            self.interactor.filterItems(with: .eventType)
        })
       
        let clear         = UIAlertAction(title: "Clear", style: .cancel, handler: { _ in
            self.interactor.filterItems(with: .none)
        })
        filterActionSheet.addAction(month)
        filterActionSheet.addAction(eventType)
        filterActionSheet.addAction(clear)

        present(filterActionSheet, animated: true, completion: nil)
    }
    
}

extension EventListController: EventGridCellDelegate, EventListCellDelegate{
    func addEventToCart(_ event: Event) {
        
        
        if (event.isPrivateEvent ?? false) {
            //Mark: get the private code
            
           addPrivateEventToCart(event)
        }else if (event.external != nil){
            self.ext.openLink(event.external?.url ?? "")
        }else{
            interactor.addEventToCart(event)
        }
    }
    
    func addPrivateEventToCart(_ event: Event){
        var selectedEvent = event
        let alert = UIAlertController(title: "Enter your secret code", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Secret Code"
        })

        alert.addAction(UIAlertAction(title: "Add To Cart", style: .default, handler: { action in

            if let secretCode = alert.textFields?.first?.text {
                selectedEvent.couponCode = secretCode
                self.interactor.addEventToCart(selectedEvent)
            }
        }))

        self.present(alert, animated: true)
    }
}
