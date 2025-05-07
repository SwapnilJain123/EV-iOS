//
//  NotificationViewController.swift
//  EvolveGT-iOS
//
//  Created by Sonali Nagde on 07/02/25.
//  Copyright © 2025 YaraTech. All rights reserved.
//

import UIKit

class NotificationViewController: ETViewController {
    
    @IBOutlet weak var notificationTableView: UITableView!
    @IBOutlet weak var noDataFoundLable: UILabel!
    
    let interactor = HomeDataInteractor()
    var notificaitonList: NotificationListResponse?
    var notifications: [NotificationItem] = []
    var currentPage = 1
    var isLoading = false
    var totalPages = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Notifications"
        self.noDataFoundLable.isHidden = true
        interactor.delegate = self
        interactor.notificationDelegate = self

        if !isLoading {
            isLoading = true
            interactor.getNotificationList(page: currentPage)
        }
    }
    
}

extension NotificationViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let notificationCell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as! NotificationTableViewCell
        
        notificationCell.setData(notificationObject: self.notifications[indexPath.row])
        return notificationCell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        if offsetY > contentHeight - frameHeight - 100 {
            if !isLoading && currentPage < totalPages {
                isLoading = true
                currentPage += 1
                interactor.getNotificationList(page: currentPage)
            }
        }
    }}

extension NotificationViewController: NotificationDelegate {
    func didFailToGetNotificaitonData() {
        self.isLoading = false
    }
    
    func didGetNotificaitonData(notificationData : NotificationListResponse?)
    {
        self.isLoading = false
        
        if let notificationObject = notificationData?.results, !notificationObject.isEmpty {
            self.noDataFoundLable.isHidden = true
            self.notifications.append(contentsOf: notificationObject)
        } else {
            self.noDataFoundLable.isHidden = false
        }
        self.notificaitonList = notificationData
        self.totalPages = notificationData?.pages ?? 0
        self.notificationTableView.reloadData()
    }
}

