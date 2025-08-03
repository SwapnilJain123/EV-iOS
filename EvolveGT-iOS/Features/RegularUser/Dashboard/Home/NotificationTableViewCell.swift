//
//  NotificationTableViewCell.swift
//  EvolveGT-iOS
//
//  Created by Sonali Nagde on 07/02/25.
//  Copyright © 2025 YaraTech. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var urlBtn: UIButton!
    @IBOutlet weak var timeLable: UILabel!
    @IBOutlet weak var typeLable: UILabel!

    var url: String = ""
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func openUrl(_ sender: Any) {
        labelTapped()
    }
    
    func labelTapped() {
            if let url = URL(string: url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    func setData(notificationObject: NotificationItem) {
        if let urlString = notificationObject.url, !urlString.isEmpty {
            self.url = notificationObject.url ?? ""
            urlBtn.setTitle(notificationObject.url, for: .normal)
            urlBtn.isHidden = false
        } else {
            urlBtn.isHidden = true
        }
        titleLable.text = notificationObject.notification?.htmlToString
        timeLable.text = notificationObject.time
        typeLable.text = notificationObject.tags
    }

}
