//
//  CreditHistoryViewController.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 09/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit

class CreditHistoryViewController: ETViewController{
    
    @IBOutlet weak var creditListTableView: UITableView!
    
    var creditHistoryList = [CreditHistory]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ext.showNavbar()
        self.ext.showBackButton()
        
        creditListTableView.dataSource = self
        
        let interactor = CreditHistoryInteractor()
        interactor.delegate = self
        interactor.fetchCreditHistory()
        
        
    }
    
    override func getScreenTitle() -> String? {
        ScreenTitle.TITLE_CREDIT_HISTORY
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.ext.hideNavbar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.ext.showBackButton()
    }
}

extension CreditHistoryViewController: UITableViewDataSource, CreditHistoryViewDelegate{
    func didFetchCreditHistory(creditHistory: [CreditHistory]) {
        self.creditHistoryList.removeAll()
        self.creditHistoryList.append(contentsOf: creditHistory)
        self.creditListTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        creditHistoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let creditCell = tableView.dequeueReusableCell(withIdentifier:"CreditHistoryItemCell",for: indexPath) as! CreditHistoryItemCell
        
        creditCell.showData(creditItem: creditHistoryList[indexPath.row])
        return creditCell;
    }
    
    
}
