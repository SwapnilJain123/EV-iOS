//
//  CompletedEventsViewController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 22/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit


class CompletedEventViewController : ETViewController{
    var searchBar: UISearchBar?
    var isSearchActive: Bool = false
    
    @IBOutlet weak var emptySearchResult: UILabel!
    
    @IBOutlet weak var menuSwitchAppMode: UIButton!
    
    @IBOutlet weak var menuLogout: UIButton!
    
    
    @IBOutlet weak var popUpMenu: UIStackView!
    
    @IBOutlet weak var eventsTableView: UITableView!
    var interactor = CompletedEventsInteractor()
    var completedEvents = [CompletedEvent]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpTableView()
        self.setInteractor()
        self.setNavbarControls()
        changeSwitchAppIcon()
        
        emptySearchResult.isHidden = true
        let homeInteractor = HomeDataInteractor()
        homeInteractor.updateDeviceToken()
    }
    
    func changeSwitchAppIcon(){
        var switcIcon = UIImage(named: "switch_moto")
        if !AppEngine.sharedInstance.isEvApp(){
            switcIcon = UIImage(named: "switch_ev")
        }
        menuSwitchAppMode.setImage(switcIcon, for: .normal)
        popUpMenu.setBackground(color: UIColor.getAppThemeColor())
    }
    func setInteractor(){
        interactor.adminDelegate = self
        interactor.viewDidLoad()
    }
    func setUpTableView(){
        eventsTableView.dataSource = self
        eventsTableView.delegate = self
    }
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        popUpMenu.isHidden = true
        if completedEvents.count > 0{
            isSearchActive = !isSearchActive
            
            if isSearchActive{
                
            }else{
                self.searchBar?.resignFirstResponder()
                //eventList = initialArrayOfEvents
                //interactor.
            }
            eventsTableView.reloadData()
        }
    }
    
    
    @IBAction func filterButtonTapped(_ sender: UIButton) {
        popUpMenu.isHidden = true
        
        if completedEvents.count > 0{
            showFilterOptions()
        }
    }
    
    override func didChangeAppTheme() {
        super.didChangeAppTheme()
        setNavbarControls()
        interactor.fetchCompletedEvents()
    }
    
    @objc func switchDashboardTapped() {
        popUpMenu.isHidden = true
        self.dashboardManager.switchToUserDashboard()
    }
    
    func setNavbarControls(){
        self.ext.hideBackButton()
        self.ext.setScreenTitle(title: ScreenTitle.TITLE_EVENTS)
        popUpMenu.isHidden = true
        
        let switchDashboard = UIBarButtonItem(image: #imageLiteral(resourceName: "SwictUserWhite"),
                                              style: .plain,
                                              target: self,
                                              action: #selector(self.switchDashboardTapped))
        let morebutton = createMoreButton()
        self.navigationItem.rightBarButtonItems = [switchDashboard, morebutton]
    }
    
    @IBAction func didPressAppSwitchMode(_ sender: Any) {
        self.dashboardManager.switchAppMode()
        changeSwitchAppIcon()
        popUpMenu.isHidden = true
    }
    
    @IBAction func didPressLogout(_ sender: Any) {
        self.didPressLogout()
    }
    //Mark: More Button
    override func didPressMoreButton() {
        
        if(isSearchActive && popUpMenu.isHidden){
            isSearchActive = false
            self.searchBar?.resignFirstResponder()
            eventsTableView.reloadData()
        }
        popUpMenu.isHidden = !popUpMenu.isHidden
        self.view.bringSubviewToFront(popUpMenu)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.ext.showBackButton()
    }
    
    
}

extension CompletedEventViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Admin", bundle: nil)
        let eventParticipantsController = storyBoard.instantiateViewController(withIdentifier: "EventParticipants") as! EventParticipantsController
        eventParticipantsController.completedEvent = completedEvents[indexPath.row]
        self.navigationController?.pushViewController(eventParticipantsController, animated: true)
    }
}
extension CompletedEventViewController : UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Log.d("Size = \(completedEvents.count)")
        return completedEvents.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompletedEvent", for: indexPath) as! CompletedEventCell
        cell.showData(completdEvent: completedEvents[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if isSearchActive {
            searchBar = UISearchBar()
            searchBar?.delegate = self
            searchBar?.accessibilityActivate()
            searchBar?.accessibilityIdentifier = "EventSearch"
            searchBar?.placeholder = "Search events here"
            searchBar?.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60)
            searchBar?.becomeFirstResponder()
            searchBar?.showsCancelButton = true
            return searchBar
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return isSearchActive ? 60 : 0
    }
    
}

extension CompletedEventViewController:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        interactor.search(query: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearchActive = false
        searchBar.text = ""
        self.searchBar?.resignFirstResponder()
        interactor.search(query: "")
        //eventsTableView.reloadData()
    }
}
extension CompletedEventViewController: CompletedEventsViewDelegate{
    func searchReturnedEmpty(message: String) {
        if message.isEmpty{
            emptySearchResult.isHidden = true
        }else{
            emptySearchResult.isHidden = false
            emptySearchResult.text = message
        }
    }
    
    
    
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
    
    func presentTrainingFilterOptions(options: [String]) {
        
        let title = "Filter by Training Type"
        
        presentSelectionMenu(title: title, data: options){
            [weak self] selectedItems in
            let selectedTraining = selectedItems.first ?? ""
            self!.interactor.filterBy(selectedTraining, .trainingType)
        }
    }
    
    func didFetchCompletedEvents(events: [CompletedEvent]) {
        completedEvents.removeAll()
        completedEvents.append(contentsOf: events)
        eventsTableView.reloadData()
    }
    
}

//Mark: Toolbar Actions
extension CompletedEventViewController{
    func showFilterOptions(){
        let filterActionSheet = UIAlertController(title: "Select filter", message: "", preferredStyle: .alert)
        let month         = UIAlertAction(title: "By Month", style: .default, handler: { _ in
            self.interactor.filterItems(with: .month)
        })
        let eventType     = UIAlertAction(title: "By Event Type", style: .default, handler: { _ in
            self.interactor.filterItems(with: .eventType)
        })
        let trainingType  = UIAlertAction(title: "By Training Type", style: .default, handler: { _ in
            self.interactor.filterItems(with: .trainingType)
        })
        let clear         = UIAlertAction(title: "Clear", style: .cancel, handler: { _ in
            self.interactor.filterItems(with: .none)
        })
        filterActionSheet.addAction(month)
        filterActionSheet.addAction(eventType)
        
        if interactor.hasFilterOptions{
            filterActionSheet.addAction(trainingType)
        }
        filterActionSheet.addAction(clear)
        
        present(filterActionSheet, animated: true, completion: nil)
    }
    
}

