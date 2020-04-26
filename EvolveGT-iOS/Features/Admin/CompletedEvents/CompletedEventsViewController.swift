//
//  CompletedEventsViewController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 22/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit

import RSSelectionMenu

class CompletedEventViewController : ETViewController{
    var searchBar: UISearchBar?
    var isSearchActive: Bool = false
    
    
    @IBOutlet weak var popUpMenu: UIStackView!
    
    @IBOutlet weak var eventsTableView: UITableView!
    var interactor = CompletedEventsInteractor()
    var completedEvents = [CompletedEvent]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpTableView()
        self.setInteractor()
        self.setNavbarControls()
        
    }
    
    func setInteractor(){
        interactor.delegate = self
        interactor.viewDidLoad()
    }
    func setUpTableView(){
        eventsTableView.dataSource = self
        eventsTableView.delegate = self
    }
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        popUpMenu.isHidden = true
        isSearchActive = !isSearchActive
        if isSearchActive{
            
        }else{
            self.searchBar?.resignFirstResponder()
            //eventList = initialArrayOfEvents
            //interactor.
        }
        eventsTableView.reloadData()
    }
    
    
    @IBAction func filterButtonTapped(_ sender: UIButton) {
        popUpMenu.isHidden = true
        showFilterOptions()
    }
    
    
    @IBAction func switchAppTapped(_ sender: UIButton) {
        popUpMenu.isHidden = true
    }
    
    @IBAction func switchDashboardTapped(_ sender: UIButton) {
        popUpMenu.isHidden = true
    }
    
    func setNavbarControls(){
        self.hideBackButton()
        self.setScreenTitle(title: ScreenTitle.TITLE_EVENTS)
        popUpMenu.setBackground(color: UIColor.getAppThemeColor())
        popUpMenu.isHidden = true
        
        let logoutItem = UIBarButtonItem(image: #imageLiteral(resourceName: "logout_icon"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(self.didPressLogout))
        let morebutton = createMoreButton()
        self.navigationItem.rightBarButtonItems = [logoutItem, morebutton]
    }
    @objc func didPressLogout(){
        Log.d("Logout !!")
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.doLogout()
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
        self.showBackButton()
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
        eventsTableView.reloadData()
    }
}
extension CompletedEventViewController: CompletedEventsViewDelegate{
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
    
    
    func didFetchCompletedEvents(events: [CompletedEvent]) {
        completedEvents.removeAll()
        completedEvents.append(contentsOf: events)
        eventsTableView.reloadData()
    }
    
    func showProgressIndicator(message: String?) {
        self.addLoadingIndicator()
    }
    
    func hideProgressIndicator() {
        self.removeLoadingIndicator()
    }
    
    func showError(message: String) {
        self.displayEmptyMessage(message: message)
    }
    
    
}

//Mark: Toolbar Actions
extension CompletedEventViewController{
    func showFilterOptions(){
        let filterActionSheet = UIAlertController(title: "Select filter", message: "", preferredStyle: .actionSheet)
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
        filterActionSheet.addAction(trainingType)
        filterActionSheet.addAction(clear)
        if DeviceType.IS_IPAD {
            filterActionSheet.popoverPresentationController?.permittedArrowDirections = []
            filterActionSheet.popoverPresentationController?.sourceView = self.view
            filterActionSheet.popoverPresentationController?.sourceRect = CGRect(x: ScreenSize.SCREEN_WIDTH / 2, y: ScreenSize.SCREEN_HEIGHT, width: 1.0, height: 1.0)
        }
        present(filterActionSheet, animated: true, completion: nil)
    }
    
}

