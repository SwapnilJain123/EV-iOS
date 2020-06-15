//
//  SettingsTableViewCells.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 14/06/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit

class SettingsLanguageCell: UITableViewCell{
    static let identifier = "SettingsLanguageCell"
    
    
    @IBOutlet weak var labelPreferredLanguage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        labelPreferredLanguage.textColor = .getAppThemeColor()
    }
}
class SettingsNotificationCell: UITableViewCell{
    static let identifier = "SettingsNotificationCell"
    
    var preference: UserPreference?
    @IBOutlet weak var labelNotificationTitle: UILabel!
    @IBOutlet weak var switchNotificationSettings: UISwitch!
    
    func populateUi(preference: UserPreference){
        self.preference = preference
        switchNotificationSettings.applySwitchTheme()
        labelNotificationTitle.text = preference.title
        switchNotificationSettings.isOn = preference.isActive
    }
    
    
    @IBAction func didChangeSwitchState(_ sender: Any) {
        self.preference?.status = switchNotificationSettings.isOn ? 1 : 0
    }
    
}
class SettingsMoreActions: UITableViewCell{
    static let identifier = "SettingsMoreActions"
    @IBOutlet weak var labelActionTitle: UILabel!
    func populateUi(preference: UserPreference){
        labelActionTitle.text = preference.title
    }
}
