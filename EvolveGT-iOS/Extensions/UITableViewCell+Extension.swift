//
//  UITableViewCell+Extension.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 01/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit

extension UITableView{
    func setEmptyBackground(rowCount: Int, message: String){
        if(rowCount == 0 ){
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
            noDataLabel.text          = message
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            self.backgroundView  = noDataLabel
            self.separatorStyle  = .none
        }else{
            self.backgroundView  = nil
        }
    }
}
extension UITableViewCell{
    func frameToCardView(backgroundView: UIView){
        backgroundView.layer.cornerRadius = 5.0
        backgroundView.layer.borderColor  =  UIColor.clear.cgColor
        backgroundView.layer.borderWidth = 5.0
        backgroundView.layer.shadowOpacity = 0.5
        backgroundView.layer.shadowColor =  UIColor.black.cgColor
        backgroundView.layer.shadowRadius = 5.0
        backgroundView.layer.shadowOffset = CGSize(width:5, height: 5)
        backgroundView.layer.masksToBounds = true
    }
}
