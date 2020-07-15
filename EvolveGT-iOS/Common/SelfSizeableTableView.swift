//
//  SelfSizeableTableView.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 08/07/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit

class SelfSizedTableView: UITableView {
  var maxHeight: CGFloat = 300 //UIScreen.main.bounds.size.height
  
  override func reloadData() {
    super.reloadData()
    self.invalidateIntrinsicContentSize()
    self.layoutIfNeeded()
  }
  
  override var intrinsicContentSize: CGSize {
    let height = min(contentSize.height, maxHeight)
    return CGSize(width: contentSize.width, height: height)
  }
}
