//
//  AlertListController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 08/07/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit

class AlertListController: UIViewController{
    
    @IBOutlet weak var rootView: UIView!
    var alertDataList = AlertListData()
    
    @IBOutlet weak var titleView: UIView!
    
    @IBOutlet weak var alertTitle: UILabel!
    @IBOutlet weak var alertListView: SelfSizedTableView!
    
    @IBOutlet weak var alertActionButton: UIButton!
    var buttonAction: (() -> Void)?
    
    
    
    var buttonTitle = "OK"
    var alertTitleText = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        alertActionButton.applyColorTheme()
        alertListView.delegate = self
        alertListView.dataSource = self
        titleView.backgroundColor = .getAppThemeColor()
        alertTitle.text = alertTitleText
        alertActionButton.setTitle(buttonTitle, for: .normal)
        rootView.setCardView()
    }
    
    @IBAction func didPressActionButton(_ sender: Any) {
        
        dismiss(animated: true)
        buttonAction?()
    }
    
    
    
}
extension AlertListController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        
        alertDataList.sections
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(alertDataList.sectionHeaderEnabled){
            return alertDataList.sectionedData[section].data.count
        }else{
            if section == 0{
                if alertDataList.hasSimpleItems{
                    return alertDataList.simpleItems?.count ?? 0
                }else{
                    return alertDataList.keyValueItems?.count ?? 0
                }
            }else{
                return alertDataList.keyValueItems?.count ?? 0
            }
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(alertDataList.sectionHeaderEnabled){
            return createKeyValueCell(indexPath: indexPath, tableView: tableView)
        }else{
            if indexPath.section == 0{
                if alertDataList.hasSimpleItems{
                    let cell = tableView.dequeueReusableCell(withIdentifier: SimpleTextCell.identifier, for: indexPath) as! SimpleTextCell
                    cell.itemTitle.text = alertDataList.simpleItems![indexPath.row]
                    return cell
                }else{
                    return createKeyValueCell(indexPath: indexPath, tableView: tableView)
                }
            }else{
                return createKeyValueCell(indexPath: indexPath, tableView: tableView)
            }
        }
        
        
    }
    private func createKeyValueCell(indexPath: IndexPath, tableView: UITableView) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: SecondaryTextCell.identifier, for: indexPath) as! SecondaryTextCell
        if(alertDataList.sectionHeaderEnabled){
            cell.leftText.text = alertDataList.sectionedData[indexPath.section].data[indexPath.row].key
            cell.rightText.text = alertDataList.sectionedData[indexPath.section].data[indexPath.row].value
        }else{
            cell.leftText.text = alertDataList.keyValueItems![indexPath.row].key
            cell.rightText.text = alertDataList.keyValueItems![indexPath.row].value
        }
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(alertDataList.sectionHeaderEnabled){
            return alertDataList.sectionedData[section].sectionTitle
        }else{
            if section == 0{
                return  alertDataList.simpleItemsTitle
            }else{
                return  alertDataList.keyValueItemsTitle
            }
        }
        
    }
    
}
class SimpleTextCell : UITableViewCell{
    static let identifier = "SimpleTextCell"
    
    @IBOutlet weak var itemTitle: UILabel!
}

class SecondaryTextCell: UITableViewCell{
    static let identifier = "SecondaryTextCell"
    
    @IBOutlet weak var rightText: UILabel!
    @IBOutlet weak var leftText: UILabel!
}
class AlertListData{
    var simpleItemsTitle = ""
    var simpleItems : [String]?
    var sectionedData = [SectionedKeyValue]()
    
    var keyValueItemsTitle = ""
    var keyValueItems : [AlertKeyValue]?
    
    var hasSimpleItems : Bool{
        simpleItems?.count != 0
    }
    var hasKeyValueItems : Bool{
        keyValueItems?.count != 0
    }
    var sections: Int{
        var numberofSection = 0
        if(sectionHeaderEnabled){
            return sectionedData.count
        }else{
            if simpleItems?.count != 0{
                numberofSection += 1
            }
            if keyValueItems?.count != 0{
                numberofSection += 1
            }
        }
        return numberofSection
    }
    
    var sectionHeaderEnabled = false
    
}

class SectionedKeyValue{
    var sectionTitle = ""
    var data = [AlertKeyValue]()
}
class AlertKeyValue{
    var key = ""
    var value = ""
}

